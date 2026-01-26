import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
}

protocol NetworkClient {
    @discardableResult
    func send(request: NetworkRequest,
              completionQueue: DispatchQueue,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask?

    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            completionQueue: DispatchQueue,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask?
}

extension NetworkClient {

    @discardableResult
    func send(request: NetworkRequest,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask? {
        send(request: request, completionQueue: .main, onResponse: onResponse)
    }

    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask? {
        send(request: request, type: type, completionQueue: .main, onResponse: onResponse)
    }
}

struct DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private let parsingQueue = DispatchQueue(
        label: "network-parsing-queue",
        qos: .userInitiated
    )
    
    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    @discardableResult
    func send(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask? {
        let onResponse: (Result<Data, Error>) -> Void = { result in
            completionQueue.async {
                onResponse(result)
            }
        }
        guard let urlRequest = create(request: request) else { return nil }
        logRequest(urlRequest)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            self.logResponse(request: urlRequest, response: response, data: data, error: error)
            guard let response = response as? HTTPURLResponse else {
                onResponse(.failure(NetworkClientError.urlSessionError))
                return
            }
            
            guard 200 ..< 300 ~= response.statusCode else {
                onResponse(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                return
            }
            
            if let data = data {
                onResponse(.success(data))
                return
            } else if let error = error {
                onResponse(.failure(NetworkClientError.urlRequestError(error)))
                return
            } else {
                assertionFailure("Unexpected condition!")
                return
            }
        }
        
        task.resume()
        
        return DefaultNetworkTask(dataTask: task)
    }
    
    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask? {
        return send(request: request, completionQueue: completionQueue) { result in
            switch result {
            case let .success(data):
                self.parse(data: data, type: type, completionQueue: completionQueue, onResponse: onResponse)
            case let .failure(error):
                onResponse(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    
    private func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else {
            assertionFailure("Empty endpoint")
            return nil
        }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        urlRequest.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        if let dtoDictionary = request.dto?.asDictionary() {
            var urlComponents = URLComponents()
            let queryItems = dtoDictionary.map { field in
                URLQueryItem(
                    name: field.key,
                    value: field.value
                )
            }
            urlComponents.queryItems = queryItems
            urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }

    private func logRequest(_ request: URLRequest) {
#if DEBUG
        let method = request.httpMethod ?? "UNKNOWN"
        let urlString = request.url?.absoluteString ?? "<no url>"
        var headers = request.allHTTPHeaderFields ?? [:]
        if headers["X-Practicum-Mobile-Token"] != nil {
            headers["X-Practicum-Mobile-Token"] = "<redacted>"
        }
        let body: String
        if let data = request.httpBody {
            if data.isEmpty {
                body = "<empty>"
            } else if let bodyString = String(data: data, encoding: .utf8) {
                body = bodyString
            } else {
                body = "<non-utf8 body: \(data.count) bytes>"
            }
        } else {
            body = "<none>"
        }
        print("""
        [Network] Request
        \(method) \(urlString)
        Headers: \(headers)
        Body: \(body)
        """)
#endif
    }

    private func logResponse(request: URLRequest, response: URLResponse?, data: Data?, error: Error?) {
#if DEBUG
        let method = request.httpMethod ?? "UNKNOWN"
        let urlString = request.url?.absoluteString ?? "<no url>"
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        let errorText = error.map { String(describing: $0) } ?? "<none>"
        let bodyText: String
        if let data = data {
            if data.isEmpty {
                bodyText = "<empty>"
            } else if let bodyString = String(data: data, encoding: .utf8) {
                let limit = 1000
                if bodyString.count > limit {
                    let idx = bodyString.index(bodyString.startIndex, offsetBy: limit)
                    bodyText = "\(bodyString[..<idx])... <truncated>"
                } else {
                    bodyText = bodyString
                }
            } else {
                bodyText = "<non-utf8 body: \(data.count) bytes>"
            }
        } else {
            bodyText = "<none>"
        }
        print("""
        [Network] Response
        \(method) \(urlString)
        Status: \(statusCode.map(String.init) ?? "nil")
        Error: \(errorText)
        Body: \(bodyText)
        """)
#endif
    }
    
    private func parse<T: Decodable>(
        data: Data,
        type _: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) {
        parsingQueue.async { [decoder] in
            let result: Result<T, Error>
            do {
                let response = try decoder.decode(T.self, from: data)
                result = .success(response)
            } catch {
                result = .failure(NetworkClientError.parsingError)
            }
            
            completionQueue.async {
                onResponse(result)
            }
        }
    }
}

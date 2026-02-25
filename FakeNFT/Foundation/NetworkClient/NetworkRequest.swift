import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    var dto: Dto? { get }
}

protocol Dto {
    func asQueryItems() -> [URLQueryItem]
}

extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var headers: [String: String] { [:] }
    var queryItems: [URLQueryItem] { [] }
    var dto: Dto? { nil }
}

extension Dto {
    func asQueryItems() -> [URLQueryItem] { [] }
}

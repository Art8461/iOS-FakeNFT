import Foundation

struct ExamplePutRequest: NetworkRequest {
   var endpoint: URL? {
       URL(string: "\(RequestConstants.baseURL)/api/v1/someMethod")
   }
   var httpMethod: HttpMethod = .put
   var dto: Dto?
}

struct ExampleDtoObject: Dto {
   let param1: String
   let param2: String

    enum CodingKeys: String, CodingKey {
        case param1 = "param_1"
        case param2
    }

    func asQueryItems() -> [URLQueryItem] {
        [
            URLQueryItem(name: CodingKeys.param1.rawValue, value: param1),
            URLQueryItem(name: CodingKeys.param2.rawValue, value: param2)
        ]
    }
}

struct ExamplePutResponse: Decodable {
    let name: String
    let devices: [String]
}

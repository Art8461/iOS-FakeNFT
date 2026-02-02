import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    var dto: Dto?
    var httpMethod: HttpMethod = .put
    let userId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

struct ProfileUpdateDto: Dto {
    let name: String
    let description: String
    let avatar: String
    let website: String
    let likes: [String]
    
    func asQueryItems() -> [URLQueryItem] {
        var items = [
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "description", value: description),
            URLQueryItem(name: "avatar", value: avatar),
            URLQueryItem(name: "website", value: website)
        ]
        if likes.isEmpty {
            items.append(URLQueryItem(name: "likes", value: "null"))
        } else {
            items += likes.map { URLQueryItem(name: "likes", value: $0) }
        }
        return items
    }
}

import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    var dto: Dto?
    var httpMethod: HttpMethod = .put
    
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
    
    func asDictionary() -> [String : String] {
        let likesValue = likes.joined(separator: ",")
        return [
            "name": name,
            "description": description,
            "avatar": avatar,
            "website": website,
            "likes": likesValue
        ]
    }
}

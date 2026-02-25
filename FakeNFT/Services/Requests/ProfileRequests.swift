import Foundation

struct FavoritesProfileRequest: NetworkRequest {
    var endpoint: URL? { URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1") }
    var httpMethod: HttpMethod { .get }
}

struct UpdateProfileLikesRequest: NetworkRequest {
    let likes: [String]
    var endpoint: URL? { URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1") }
    var httpMethod: HttpMethod { .put }
    var dto: Dto? { LikesDto(likes: likes) }
}

private struct LikesDto: Dto {
    let likes: [String]

    func asQueryItems() -> [URLQueryItem] {
        likes.map { URLQueryItem(name: "likes", value: $0) }
    }
}


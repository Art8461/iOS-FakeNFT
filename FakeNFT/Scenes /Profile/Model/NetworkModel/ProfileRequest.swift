//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 30.01.2026.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/api/v1/profile/1")
    }

    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}

struct UpdateProfileDto: Dto {
    let name: String
    let description: String
    let avatar: String
    let website: String
    let likes: [String]

    func asDictionary() -> [String : String] {[:]}

    func asQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = [
            .init(name: "name", value: name),
            .init(name: "description", value: description),
            .init(name: "avatar", value: avatar),
            .init(name: "website", value: website)
        ]
        if likes.isEmpty {
            items.append(.init(name: "likes", value: "null"))
        } else {
            items += likes.map {
                URLQueryItem(name: "likes", value: $0)
            }
        }
        return items
    }
}

struct UpdateProfileRequest: NetworkRequest {

    let dtoData: UpdateProfileDto

    var endpoint: URL? {
        var components = URLComponents(
            string: RequestConstants.baseURL + "/api/v1/profile/1"
        )
        components?.queryItems = dtoData.asQueryItems()
        return components?.url
    }

    var httpMethod: HttpMethod { .put }
    var dto: Dto? { nil }
}

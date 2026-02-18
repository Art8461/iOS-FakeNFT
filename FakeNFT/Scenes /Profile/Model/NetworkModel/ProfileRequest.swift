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

struct UpdateProfileRequest: NetworkRequest {
    
    let dtoData: UpdateProfileDto
    
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod { .put }
    var dto: Dto? { dtoData }
}

struct UpdateProfileDto: Dto {
    
    let name: String
    let description: String
    let avatar: String
    let website: String
    let likes: [String]
    
    func asQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "description", value: description),
            URLQueryItem(name: "avatar", value: avatar),
            URLQueryItem(name: "website", value: website)
        ]
        if !likes.isEmpty {
            items.append(contentsOf: likes.map {
                URLQueryItem(name: "likes", value: $0)
            })
        }
        
        return items
    }
}

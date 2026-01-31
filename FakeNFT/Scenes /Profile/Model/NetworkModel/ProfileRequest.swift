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
    let website: String
    let avatar: String?
    
    func asDictionary() -> [String: String] {
        return [
            "name": name,
            "description": description,
            "website": website,
            "avatar": avatar ?? ""
        ]
    }
}

struct UpdateProfileRequest: NetworkRequest {
    let dtoData: UpdateProfileDto
    
    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod { .put }
    
    var dto: Dto? {
        return dtoData
    }
}

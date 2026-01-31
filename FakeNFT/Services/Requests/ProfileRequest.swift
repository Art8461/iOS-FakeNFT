//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 30.01.2026.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var dto: Dto? { nil }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

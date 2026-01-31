//
//  ProfileStatsRequest.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 30.01.2026.
//

import Foundation

struct ProfileStatsRequest: NetworkRequest {
    var dto: Dto? { nil }
    let userId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(userId)")
    }
}

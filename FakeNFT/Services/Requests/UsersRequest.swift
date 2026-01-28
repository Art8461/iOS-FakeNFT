//
//  UsersRequest.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 28.01.2026.
//

import Foundation

struct UsersRequest: NetworkRequest {
    let page: Int
    var dto: Dto? { nil }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users?page=\(page)")
    }
}

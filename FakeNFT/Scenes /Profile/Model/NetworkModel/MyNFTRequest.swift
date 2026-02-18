//
//  MyNFTRequest.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 01.02.2026.
//

import Foundation

struct MyNFTRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: RequestConstants.baseURL + "/api/v1/nft/\(id)")
    }

    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}

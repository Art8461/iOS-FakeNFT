//
//  UpdateOrderRequest.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 22.01.2026.
//

import Foundation

struct UpdateOrderRequest: NetworkRequest {
    let dto: Dto?
    var httpMethod: HttpMethod { .put }
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct UpdateOrderDto: Dto {
    let nfts: [String]

    func asDictionary() -> [String : String] {
        ["nfts": nfts.joined(separator: ",")]
    }
}

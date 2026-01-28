//
//  CompleteOrderRequest.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 25.01.2026.
//

import Foundation

struct CompleteOrderRequest: NetworkRequest {
    let dto: Dto?
    var httpMethod: HttpMethod { .post }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
struct CompleteOrderDto: Dto {
    let id: String
    //let nfts: [String]

    func asDictionary() -> [String : String] {
        [
            "id": id,
        ]
    }
}

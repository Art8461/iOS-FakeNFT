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

    init(dto: Dto?) {
        self.dto = dto
    }

    init(nfts: [String], orderId: String = "1") {
        self.dto = UpdateOrderDto(id: orderId, nfts: nfts)
    }
}

struct UpdateOrderDto: Dto {
    let id: String
    let nfts: [String]

    func asQueryItems() -> [URLQueryItem] {
        var items = [URLQueryItem(name: "id", value: id)]
        if !nfts.isEmpty {
            let nftsValue = nfts.joined(separator: ",")
            items.append(URLQueryItem(name: "nfts", value: nftsValue))
        }
        return items
    }
}

//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 22.01.2026.
//

import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var dto: Dto? { nil }
}

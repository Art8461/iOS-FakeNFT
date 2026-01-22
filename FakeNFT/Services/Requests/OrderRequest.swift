//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 22.01.2026.
//

import Foundation

struct OrderRequest: NetworkRequest {
    var dto: (any Dto)?
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

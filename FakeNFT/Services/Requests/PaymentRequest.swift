//
//  PaymentRequest.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 25.01.2026.
//

import Foundation

struct PaymentRequest: NetworkRequest {
    let currencyId: String
    var dto: Dto? { nil }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
    }
}

//
//  PaymentResponse.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 25.01.2026.
//

import Foundation

struct PaymentResponse: Decodable {
    let success: Bool
    let orderId: String
    let id: String
}

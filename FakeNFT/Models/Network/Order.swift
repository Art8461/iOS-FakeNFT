//
//  Order.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 22.01.2026.
//

import Foundation

struct Order: Decodable {
    let id: String
    let nfts: [String]
}

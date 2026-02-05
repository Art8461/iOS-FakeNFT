//
//  Currency.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 25.01.2026.
//

import Foundation

struct Currency: Decodable {
    let id: String
    let title: String
    let name: String
    let image: URL?
}

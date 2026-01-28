//
//  User.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 28.01.2026.
//

import Foundation

struct User: Decodable {
    let id: String
    let name: String
    let avatar: URL?
    let nfts: [String]
}

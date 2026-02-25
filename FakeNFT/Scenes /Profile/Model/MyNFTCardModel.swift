//
//  MyNFTCardModel.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 26.01.2026.
//

import Foundation

struct NFTCartModel: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}

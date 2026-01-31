//
//  MyNFTCardModel.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 26.01.2026.
//

import Foundation

struct NFTCartModel {
    let id: String
    let imageName: String
    let imageURL: URL?
    let isLiked: Bool
    let title: String
    let authorName: String?
    let price: Float
    let rating: Int
}

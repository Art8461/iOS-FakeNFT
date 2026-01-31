//
//  MyNFTCardModel.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 26.01.2026.
//

import Foundation

struct NFTCartModel {
    let imageName: String
    let imageURL: URL?
    let likeImageName: String
    let title: String
    let starsImageName: String  
    let authorName: String?
    let price: Float
    let rating: Int
}

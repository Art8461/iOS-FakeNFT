//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 23.01.2026.
//

import Foundation

struct ProfileResponse: Decodable {
    let name: String
    let avatar: String?
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

enum ProfileItemType {
    case myNFT
    case myFavorites

    var title: String {
        switch self {
        case .myNFT:
            return "Мои NFT"
        case .myFavorites:
            return "Избранные NFT"
        }
    }
}

struct ProfileItem {
    let type: ProfileItemType
    let count: Int
}

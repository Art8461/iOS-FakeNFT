//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 23.01.2026.
//

import Foundation

enum ProfileItemType {
    case myNFT
    case myFavorites
    case collection
    
    var title: String {
        switch self {
        case .myNFT:
            return "Мои NFT"
        case .myFavorites:
            return "Избранные NFT"
        case .collection:
            return "Коллекция NFT"
        }
    }
}

enum ProfileMode: Equatable{
    case myProfile
    case user(id: String)
}

struct ProfilUserItem{
    let id: String
    let name: String
    let avatar: URL?
    let description: String?
    let website: String?
    let nfts: [String]
    let likes: [String]?
}

struct ProfileItem {
    let type: ProfileItemType
    let count: Int
}

struct ProfileEditModel {
    let id: String
    let name: String
    let description: String
    let site: String
    let avatar: URL?
    let likes: [String]
}

struct ProfileUpdateData {
    let id: String
    let name: String
    let description: String
    let avatar: String
    let website: String
}

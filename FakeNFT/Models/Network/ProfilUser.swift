//
//  ProfilUser.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 30.01.2026.
//

import Foundation

struct ProfilUser: Decodable {
    let id: String
    let name: String
    let avatar: URL?
    let description: String?
    let website: String?
    let nfts: [String]
    let likes: [String]?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatar
        case description
        case website
        case nfts
        case likes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        website = try container.decodeIfPresent(String.self, forKey: .website)
        nfts = try container.decodeIfPresent([String].self, forKey: .nfts) ?? []

        if let avatarString = try container.decodeIfPresent(String.self, forKey: .avatar),
           let url = URL(string: avatarString),
           !avatarString.isEmpty {
            avatar = url
        } else {
            avatar = nil
        }

        if let likesArray = try container.decodeIfPresent([String].self, forKey: .likes) {
            likes = likesArray
        } else if let likesString = try container.decodeIfPresent(String.self, forKey: .likes) {
            likes = likesString
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        } else {
            likes = nil
        }
    }
}

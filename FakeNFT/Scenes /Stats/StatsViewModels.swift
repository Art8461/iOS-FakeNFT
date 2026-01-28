//
//  StatsViewModels.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 28.01.2026.
//

import Foundation

struct StatsItemCellModel {
    let id: String
    let name: String
    let avatar: URL?
    let nfts: Array<String>
    let rating: Int
}

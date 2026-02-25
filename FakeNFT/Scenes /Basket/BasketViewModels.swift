//
//  BasketViewModels.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 22.01.2026.
//

import Foundation

struct BasketItemCellModel {
    let id: String
    let title: String
    let priceText: String
    let rating: Int
    let imageURL: URL?
}

struct BasketSummaryViewModel {
    let countText: String
    let totalText: String
}

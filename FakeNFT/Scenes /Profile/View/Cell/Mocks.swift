//
//  Mocks.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 26.01.2026.
//

import Foundation

enum NFTMockData {

    static func myNFTs() -> [NFTCartModel] {
        [
            NFTCartModel(
                id: "1",
                imageName: "NFTCardTest",
                imageURL: nil,
                isLiked: false,
                title: "Test",
                authorName: "Andrey P",
                price: 1.78,
                rating: 3
            ),
            NFTCartModel(
                id: "2",
                imageName: "NFTCardTest2",
                imageURL: nil,
                isLiked: false,
                title: "Test 2",
                authorName: "Andrey P",
                price: 2.50,
                rating: 3
            ),
            NFTCartModel(
                id: "3",
                imageName: "NFTCardTest3",
                imageURL: nil,
                isLiked: false,
                title: "Test 3",
                authorName: "Andrey P",
                price: 3.12,
                rating: 3
            )
        ]
    }
}

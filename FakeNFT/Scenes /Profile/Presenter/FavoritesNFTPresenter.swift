//
//  FavoritesNFTPresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 24.01.2026.
//

import Foundation

protocol FavoritesNFTPresenterProtocol: AnyObject {
    func didTapBack()
    func viewDidLoad()
}

final class FavoritesNFTPresenter: FavoritesNFTPresenterProtocol {
    
    weak var view: FavoritesNFTViewProtocol?
    
    private let nftIds: [String]
    private let nftService: NftService
    private var currentNfts: [Nft] = []

    init(nftIds: [String], nftService: NftService) {
        self.nftIds = nftIds
        self.nftService = nftService
    }
    
    func didTapBack() {
        view?.closeScreen()
    }

    func viewDidLoad() {
        loadNfts()
    }

    private func loadNfts() {
        guard !nftIds.isEmpty else {
            currentNfts = []
            view?.display(items: [])
            return
        }

        let group = DispatchGroup()
        var nftsById: [String: Nft] = [:]

        nftIds.forEach { id in
            group.enter()
            nftService.loadNft(id: id) { result in
                DispatchQueue.main.async {
                    if case .success(let nft) = result {
                        nftsById[nft.id] = nft
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.currentNfts = self.nftIds.compactMap { nftsById[$0] }
            let models = self.currentNfts.map { self.makeModel(from: $0) }
            self.view?.display(items: models)
        }
    }

    private func makeModel(from nft: Nft) -> NFTCartModel {
        NFTCartModel(
            imageName: "NFTCardTest",
            imageURL: nft.images.first,
            likeImageName: "Favourites",
            title: nft.name,
            starsImageName: "Rating3",
            authorName: nft.author,
            price: Float(nft.price),
            rating: nft.rating
        )
    }
    
}

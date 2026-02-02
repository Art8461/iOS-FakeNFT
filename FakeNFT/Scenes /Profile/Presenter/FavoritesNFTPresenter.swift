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
    func didTapLike(id: String)
}

final class FavoritesNFTPresenter: FavoritesNFTPresenterProtocol {
    
    weak var view: FavoritesNFTViewProtocol?
    
    private let nftIds: [String]
    private var likedIds: Set<String>
    private let nftService: NftService
    private let profileService: ProfileService
    private let profileUpdateData: ProfileUpdateData
    private var currentNfts: [Nft] = []

    init(
        nftIds: [String],
        nftService: NftService,
        profileService: ProfileService,
        profileUpdateData: ProfileUpdateData
    ) {
        self.nftIds = nftIds
        self.likedIds = Set(nftIds)
        self.nftService = nftService
        self.profileService = profileService
        self.profileUpdateData = profileUpdateData
    }
    
    func didTapBack() {
        view?.closeScreen()
    }

    func viewDidLoad() {
        loadNfts()
    }

    func didTapLike(id: String) {
        guard likedIds.contains(id) else { return }
        likedIds.remove(id)
        currentNfts.removeAll { $0.id == id }
        let models = currentNfts.map { makeModel(from: $0) }
        view?.display(items: models)
        updateLikes()
    }

    private func loadNfts() {
        view?.displayLoading(true)
        guard !nftIds.isEmpty else {
            currentNfts = []
            view?.display(items: [])
            view?.displayLoading(false)
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
            self.view?.displayLoading(false)
        }
    }

    private func makeModel(from nft: Nft) -> NFTCartModel {
        let isLiked = likedIds.contains(nft.id)
        return NFTCartModel(
            id: nft.id,
            imageName: "NFTCardTest",
            imageURL: nft.images.first,
            isLiked: isLiked,
            title: nft.name,
            authorName: nft.author,
            price: Float(nft.price),
            rating: nft.rating
        )
    }

    private func updateLikes() {
        let likes = Array(likedIds)
        profileService.updateProfile(
            data: profileUpdateData,
            likes: likes
        ) { _ in }
    }
    
}

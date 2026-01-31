//
//  MyNFTsPresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 24.01.2026.
//

import Foundation

protocol MyNFTsPresenterProtocol: AnyObject {
    func didTapBack()
    func viewDidLoad()
    func didTapSort()
    func didSelectSortOption(_ option: Sorting)
    func didTapLike(id: String)
}

final class MyNFTsPresenter: MyNFTsPresenterProtocol {
    
    weak var view: MyNFTsViewProtocol?

    private let nftIds: [String]
    private var likedIds: Set<String>
    private let nftService: NftService
    private let profileService: ProfileService
    private let profileUpdateData: ProfileUpdateData
    private var currentNfts: [Nft] = []
    private var sortOption: Sorting?

    init(
        nftIds: [String],
        likedIds: [String],
        nftService: NftService,
        profileService: ProfileService,
        profileUpdateData: ProfileUpdateData
    ) {
        self.nftIds = nftIds
        self.likedIds = Set(likedIds)
        self.nftService = nftService
        self.profileService = profileService
        self.profileUpdateData = profileUpdateData
    }
    
    func viewDidLoad() {
        loadNfts()
    }
    
    func didTapBack() {
        view?.closeScreen()
    }
    
    func didTapSort() {
        let options: [Sorting] = [.price, .rating, .name]
        view?.showSortAlert(options: options)
    }
    
    func didSelectSortOption(_ option: Sorting) {
        sortOption = option
        applySortAndDisplay()
    }

    func didTapLike(id: String) {
        if likedIds.contains(id) {
            likedIds.remove(id)
        } else {
            likedIds.insert(id)
        }
        applySortAndDisplay()
        updateLikes()
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
            self.applySortAndDisplay()
        }
    }

    private func applySortAndDisplay() {
        let sortedNfts = sorted(currentNfts)
        let models = sortedNfts.map { makeModel(from: $0) }
        view?.display(items: models)
    }

    private func sorted(_ nfts: [Nft]) -> [Nft] {
        guard let sortOption else { return nfts }
        switch sortOption {
        case .price:
            return nfts.sorted { lhs, rhs in
                if lhs.price == rhs.price {
                    return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
                }
                return lhs.price > rhs.price
            }
        case .rating:
            return nfts.sorted { lhs, rhs in
                if lhs.rating == rhs.rating {
                    return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
                }
                return lhs.rating > rhs.rating
            }
        case .name:
            return nfts.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
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

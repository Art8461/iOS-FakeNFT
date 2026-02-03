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
    func didTapLike(nftId: String)
}

final class MyNFTsPresenter: MyNFTsPresenterProtocol {
    
    weak var view: MyNFTsViewProtocol?
    private let profileService: ProfileServiceProtocol
    private let myNFTsService: MyNFTsServiceProtocol
    private var nfts: [NFTCartModel] = []
    private var likedIds: Set<String> = []
    
    init(
        profileService: ProfileServiceProtocol,
        myNFTsService: MyNFTsServiceProtocol
    ) {
        self.profileService = profileService
        self.myNFTsService = myNFTsService
    }
    
    func viewDidLoad() {
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.likedIds = Set(profile.likes)
                self.loadMyNFTs(ids: profile.nfts)
            case .failure(let error):
                print("Ошибка загрузки профиля:", error)
            }
        }
    }

    func didTapBack() {
        view?.closeScreen()
    }
    
    func didTapSort() {
        let options: [Sorting] = [.price, .rating, .name]
        view?.showSortAlert(options: options)
    }
    
    func didSelectSortOption(_ option: Sorting) {
        switch option {
        case .price:
            nfts.sort { $0.price < $1.price }
        case .rating:
            nfts.sort { $0.rating > $1.rating }
        case .name:
            nfts.sort { $0.name < $1.name }
        }
        view?.showNFTs(nfts, likedIds: Array(likedIds))
    }

    private func loadMyNFTs(ids: [String]) {
        myNFTsService.fetchMyNFTs(ids: ids) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.nfts = nfts
                self.view?.showNFTs(nfts, likedIds: Array(self.likedIds))
            case .failure(let error):
                print("Ошибка загрузки NFT:", error)
            }
        }
    }
    
    func didTapLike(nftId: String) {
        if likedIds.contains(nftId) {
            likedIds.remove(nftId)
            profileService.removeLike(nftId: nftId) { result in
                if case .failure(let error) = result {
                    print("Ошибка удаления лайка:", error)
                }
            }
        } else {
            likedIds.insert(nftId)
            profileService.addLike(nftId: nftId) { result in
                if case .failure(let error) = result {
                    print("Ошибка добавления лайка:", error)
                }
            }
        }
        view?.showNFTs(nfts, likedIds: Array(likedIds))
    }
}

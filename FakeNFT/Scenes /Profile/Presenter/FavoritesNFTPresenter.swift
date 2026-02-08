//
//  FavoritesNFTPresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 24.01.2026.
//

import Foundation

protocol FavoritesNFTPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapBack()
    func didTapLike(nftId: String)
}

final class FavoritesNFTPresenter: FavoritesNFTPresenterProtocol {
    
    weak var view: FavoritesNFTViewProtocol?
    
    private let profileService: ProfileServiceProtocol
    private let myNFTsService: MyNFTsServiceProtocol
    
    private var favoritesNFTs: [NFTCartModel] = []
    
    init(
        profileService: ProfileServiceProtocol,
        myNFTsService: MyNFTsServiceProtocol
    ) {
        self.profileService = profileService
        self.myNFTsService = myNFTsService
    }
    
    func viewDidLoad() {
        loadFavorites()
    }
    
    func didTapBack() {
        view?.closeScreen()
    }
    
    func didTapLike(nftId: String) {
        profileService.removeLike(nftId: nftId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.favoritesNFTs.removeAll { $0.id == nftId }
                    self.view?.showNFTs(self.favoritesNFTs)
                case .failure(let error):
                    print("Ошибка удаления лайка:", error)
                    self.view?.showErrorRetry { [weak self] in
                        self?.didTapLike(nftId: nftId)
                    }
                }
            }
        }
    }
    
    private func loadFavorites() {
        profileService.fetchProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.loadNFTs(ids: profile.likes)
            case .failure:
                DispatchQueue.main.async {
                    self.view?.showErrorRetry { [weak self] in
                        self?.viewDidLoad()
                    }
                }
            }
        }
    }
    
    private func loadNFTs(ids: [String]) {
        myNFTsService.fetchMyNFTs(ids: ids) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let nfts):
                self.favoritesNFTs = nfts
                DispatchQueue.main.async {
                    self.view?.showNFTs(self.favoritesNFTs)
                }
            case .failure:
                DispatchQueue.main.async {
                    self.view?.showErrorRetry { [weak self] in
                        self?.loadNFTs(ids: ids)
                    }
                }
            }
        }
    }
}

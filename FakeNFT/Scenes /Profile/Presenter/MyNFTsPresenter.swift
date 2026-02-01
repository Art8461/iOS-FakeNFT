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
}

final class MyNFTsPresenter: MyNFTsPresenterProtocol {
    
    weak var view: MyNFTsViewProtocol?
    private let profileService: ProfileServiceProtocol
    private let myNFTsService: MyNFTsServiceProtocol
    private var nfts: [NFTCartModel] = []
    
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

        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            let likedIds = (try? result.get().likes) ?? []
            self.view?.showNFTs(nfts, likedIds: likedIds)
        }
    }


    private func loadMyNFTs(ids: [String]) {
        myNFTsService.fetchMyNFTs(ids: ids) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let nfts):
                self.nfts = nfts
                self.profileService.fetchProfile { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let profile):
                        self.view?.showNFTs(nfts, likedIds: profile.likes)
                    case .failure(let error):
                        print("Ошибка профиля:", error)
                    }
                }

            case .failure(let error):
                print(error)
            }
        }
    }
    
}

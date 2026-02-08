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
    private var currentSorting = Sorting.load()
    
    init(
        profileService: ProfileServiceProtocol,
        myNFTsService: MyNFTsServiceProtocol
    ) {
        self.profileService = profileService
        self.myNFTsService = myNFTsService
    }
    
    func viewDidLoad() {
        profileService.fetchProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.likedIds = Set(profile.likes)
                self.loadMyNFTs(ids: profile.nfts)
            case .failure:
                DispatchQueue.main.async {
                    self.view?.showErrorRetry { [weak self] in
                        self?.viewDidLoad()
                    }
                }
            }
        }
    }
    
    func didTapBack() {
        view?.closeScreen()
    }
    
    func didTapSort() {
        view?.showSortAlert(options: Sorting.allCases)
    }
    
    func didSelectSortOption(_ option: Sorting) {
        applySorting(option)
    }
    
    private func applySorting(_ sorting: Sorting) {
        currentSorting = sorting
        Sorting.save(sorting)
        
        switch sorting {
        case .price:
            nfts.sort { $0.price < $1.price }
        case .rating:
            nfts.sort { $0.rating > $1.rating }
        case .name:
            nfts.sort { $0.name < $1.name }
        }
        DispatchQueue.main.async {
            self.view?.showNFTs(self.nfts,
                                likedIds: Array(self.likedIds),
                                currentSorting: self.currentSorting)
        }
    }
    
    private func loadMyNFTs(ids: [String]) {
        myNFTsService.fetchMyNFTs(ids: ids) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.nfts = nfts
                self.applySorting(self.currentSorting)
            case .failure:
                DispatchQueue.main.async {
                    self.view?.showErrorRetry { [weak self] in
                        self?.viewDidLoad()
                    }
                }
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
        DispatchQueue.main.async {
            self.view?.showNFTs(self.nfts,
                                likedIds: Array(self.likedIds),
                                currentSorting: self.currentSorting)
        }
    }
}

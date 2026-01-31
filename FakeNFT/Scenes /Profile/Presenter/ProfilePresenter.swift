//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 22.01.2026.
//

import Foundation
import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func refresh()
    func didTapEdit()
    func openMyNFTs()
    func openFavoritesNFC()
    func didTapWebSite(url: String)
}



final class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewProtocol?

    private let mode: ProfileMode
    private let profileService: ProfileService

    init(mode: ProfileMode = .myProfile, profileService: ProfileService) {
        self.mode = mode
        self.profileService = profileService
    }
    
    func viewDidLoad() {
        let isMyProfile = (mode == .myProfile)
        view?.setEditVisible(isMyProfile)
        view?.setBackButtonVisible(!isMyProfile)

        if isMyProfile {
            view?.configureWebsite(isButton: false, spacingAfterDescription: 8)
        } else {
            view?.configureWebsite(isButton: true, spacingAfterDescription: 28)
        }
        view?.setWebsiteAsButton(mode != .myProfile)

        let items: [ProfileItem] = isMyProfile
        ? [ProfileItem(type: .myNFT, count: 0), ProfileItem(type: .myFavorites, count: 0)]
        : [ProfileItem(type: .myNFT, count: 0)]

        view?.setMenuItems(items)
        loadProfile()
    }
    
    func refresh() {
        loadProfile()
    }
    
    func didTapEdit() {
        guard mode == .myProfile else { return }
        guard let model = view?.getProfileEditModel() else { return }
        view?.openEditProfile(model: model)
    }
    
    func openMyNFTs() {
        view?.openMyNFTs()
    }
    
    func openFavoritesNFC() {
        guard mode == .myProfile else { return }
        view?.openFavoritesNFTs()
    }
    
    func didTapWebSite(url: String) {
        guard let url = URL(string: url) else {
            print("Некорректный URL: \(url)")
            return
        }
        view?.openWebView(url: url)
    }

    private func loadProfile() {
        let completion: ProfileCompletion = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self.view?.display(profile: self.makeProfileItem(from: profile))
                    self.view?.setMenuItems(self.makeMenuItems(from: profile))
                case .failure:
                    self.view?.showError(self.makeErrorModel())
                }
            }
        }

        switch mode {
        case .myProfile:
            profileService.loadMyProfile(completion: completion)
        case .user(let id):
            profileService.loadProfile(userId: id, completion: completion)
        }
    }

    private func makeProfileItem(from profile: ProfilUser) -> ProfilUserItem {
        ProfilUserItem(
            id: profile.id,
            name: profile.name,
            avatar: profile.avatar,
            description: profile.description,
            website: profile.website,
            nfts: profile.nfts,
            likes: profile.likes
        )
    }

    private func makeMenuItems(from profile: ProfilUser) -> [ProfileItem] {
        let nftCount = profile.nfts.count
        let favoritesCount = profile.likes?.count ?? 0
        switch mode {
        case .myProfile:
            return [
                ProfileItem(type: .myNFT, count: nftCount),
                ProfileItem(type: .myFavorites, count: favoritesCount)
            ]
        case .user:
            return [ProfileItem(type: .myNFT, count: nftCount)]
        }
    }

    private func makeErrorModel() -> ErrorModel {
        let primary = ErrorAction(
            title: NSLocalizedString("Error.repeat", comment: ""),
            style: .default
        ) { [weak self] in
            self?.loadProfile()
        }
        let secondary = ErrorAction(
            title: NSLocalizedString("Error.close", comment: ""),
            style: .cancel
        ) { }
        return ErrorModel(
            message: NSLocalizedString("Error.network", comment: ""),
            primaryAction: primary,
            secondaryAction: secondary
        )
    }
}



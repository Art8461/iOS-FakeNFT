//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 22.01.2026.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapEdit()
    func openMyNFTs()
    func openFavoritesNFC()
    func didTapWebSite(url: String)
}



final class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewProtocol?

    private let mode: ProfileMode

    init(mode: ProfileMode = .myProfile) {
        self.mode = mode
    }
    
    func viewDidLoad() {
        let isMyProfile = (mode == .myProfile)
        view?.setEditVisible(isMyProfile)

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
}



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
    private let service: ProfileServiceProtocol
    private let router: ProfileRouterProtocol
    
    private var profile: ProfileResponse?
    
    init(
        service: ProfileServiceProtocol,
        router: ProfileRouterProtocol
    ) {
        self.service = service
        self.router = router
    }
    
    func viewDidLoad() {
        service.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self?.profile = profile
                    self?.view?.updateProfile(profile)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didTapEdit() {
        guard let profile else { return }
        let model = ProfileEditModel(
            name: profile.name,
            description: profile.description,
            site: profile.website,
            avatar: profile.avatar
        )
        router.showProfileEdit(model: model, profile: profile)
    }
    
    func openMyNFTs() {
        router.showMyNFTs()
    }
    
    func openFavoritesNFC() {
        router.showFavoritesNFTs()
    }
    
    func didTapWebSite(url: String) {
        guard let url = URL(string: url) else { return }
        router.showWebView(url: url)
    }
}

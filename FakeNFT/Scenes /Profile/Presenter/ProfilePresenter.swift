//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 22.01.2026.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func didTapEdit()
    func openMyNFTs()
    func openFavoritesNFT()
    func didTapWebSite(url: String)
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    private let service: ProfileServiceProtocol
    private let router: ProfileRouterProtocol
    private var profile: ProfileResponse?
    private var hasLoadedInitially = false
    
    init(
        service: ProfileServiceProtocol,
        router: ProfileRouterProtocol
    ) {
        self.service = service
        self.router = router
    }
    
    func viewDidLoad() {
        loadProfile()
    }
    
    func viewWillAppear() {
        if hasLoadedInitially {
            loadProfile()
        } else {
            hasLoadedInitially = true
        }
    }
    
    func loadProfile() {
        service.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self?.profile = profile
                    self?.view?.updateProfile(profile)
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.view?.showErrorRetry { [weak self] in
                        self?.viewDidLoad()
                    }
                }
                
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
    
    func openFavoritesNFT() {
        router.showFavoritesNFTs()
    }
    
    func didTapWebSite(url: String) {
        guard let url = URL(string: url) else { return }
        router.showWebView(url: url)
    }
}

//
//  ProfileRouter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 03.02.2026.
//

import UIKit

protocol ProfileRouterProtocol: AnyObject {
    
    func showProfileEdit(model: ProfileEditModel, profile: ProfileResponse)
    func showMyNFTs()
    func showFavoritesNFTs()
    func showWebView(url: URL)
}


final class ProfileRouter: ProfileRouterProtocol {
    
    private let services: ServicesAssembly
    private let navigationController: UINavigationController
    
    init(
        services: ServicesAssembly,
        navigationController: UINavigationController
    ) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func showProfile() {
        let presenter = ProfilePresenter(
            service: services.profileService,
            router: self
        )
        let vc = ProfileViewController(presenter: presenter)
        presenter.view = vc
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showProfileEdit(model: ProfileEditModel, profile: ProfileResponse) {
        let presenter = ProfileEditPresenter(
            model: model,
            currentProfile: profile,
            service: services.profileService
        )
        let vc = ProfileEditViewController(presenter: presenter)
        presenter.view = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showMyNFTs() {
        let presenter = MyNFTsPresenter(
            profileService: services.profileService,
            myNFTsService: services.myNFTsService
        )
        let vc = MyNFTsViewController(presenter: presenter)
        presenter.view = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showFavoritesNFTs() {
        let presenter = FavoritesNFTPresenter(
            profileService: services.profileService,
            myNFTsService: services.myNFTsService
        )
        let vc = FavoritesNFTViewController(presenter: presenter)
        presenter.view = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showWebView(url: URL) {
        let presenter = WebViewPresenter()
        let vc = WebViewProfile(url: url, presenter: presenter)
        presenter.view = vc
        navigationController.pushViewController(vc, animated: true)
    }
}

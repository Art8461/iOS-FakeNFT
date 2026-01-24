//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 22.01.2026.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func didTapEdit()
    func openMyNFTs()
    func openFavoritesNFC()
}



final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    
    func didTapEdit() {
        guard let model = view?.getProfileEditModel() else { return }
        view?.openEditProfile(model: model)
    }
    
    func openMyNFTs() {
        view?.openMyNFTs()
    }
    
    func openFavoritesNFC() {
        view?.openFavoritesNFTs()
    }
}



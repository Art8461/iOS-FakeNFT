//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 22.01.2026.
//

import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    func didTapEdit()
    func openMyNFTs()
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
}



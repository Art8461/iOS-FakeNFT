//
//  ProfileEditPresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 23.01.2026.
//

import Foundation

protocol ProfileEditPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapBack()
    
}

final class ProfileEditPresenter: ProfileEditPresenterProtocol {
    
    weak var view: ProfileEditViewProtocol?
    private let model: ProfileEditModel
    
    init(model: ProfileEditModel) {
        self.model = model
    }
    
    func viewDidLoad() {
        view?.showProfile(model: model)
    }
    
    func didTapBack() {
        view?.closeSave()
    }
}

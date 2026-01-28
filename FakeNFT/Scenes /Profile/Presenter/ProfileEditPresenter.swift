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
    func didTapExit()
    func didTapAvatar()
    func didSelectChangePhoto()
    func didSelectDeletePhoto()
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
        view?.showExitAlert()
    }
    
    // Пользователь подтвердил выход
    func didTapExit() {
        view?.closeSave()
    }
    
    func didTapAvatar() {
        view?.showAvatarAlert()
    }
    
    // Пользователь выбрал изменить фото
    func didSelectChangePhoto() {
        print("Логика изменения фото")
    }
    
    // Пользователь выбрал удалить фото
    func didSelectDeletePhoto() {
        print("Логика удаления фото")
    }
}

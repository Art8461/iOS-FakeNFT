//
//  ProfileEditPresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 23.01.2026.
//

import Foundation
import UIKit

protocol ProfileEditPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapBack()
    func didTapExit()
    func didTapAvatar()
    func didSelectChangePhoto()
    func didSelectDeletePhoto()
    func didTapSave(name: String, description: String, site: String, avatarURL: URL?)
}

final class ProfileEditPresenter: ProfileEditPresenterProtocol {
    
    weak var view: ProfileEditViewProtocol?
    private let model: ProfileEditModel
    private let profileService: ProfileService
    
    init(model: ProfileEditModel, profileService: ProfileService) {
        self.model = model
        self.profileService = profileService
    }
    
    func viewDidLoad() {
        view?.showProfile(model: model)
    }
    
    func didTapBack() {
        view?.showExitAlert()
    }
    
    func didTapExit() {
        view?.closeSave()
    }
    
    func didTapAvatar() {
        view?.showAvatarAlert()
    }
    
    func didSelectChangePhoto() {
        view?.showPhotoLinkAlert()
        print("Алерт для ввода ссылки на фото показан")
    }
    
    func didSelectDeletePhoto() {
        print("Логика удаления фото")
    }

    func didTapSave(name: String, description: String, site: String, avatarURL: URL?) {
        let data = ProfileUpdateData(
            id: model.id,
            name: name,
            description: description,
            avatar: avatarURL?.absoluteString ?? "",
            website: site
        )
        updateProfile(data: data, likes: model.likes)
    }
    
    private func updateProfile(data: ProfileUpdateData, likes: [String]) {
        view?.displayLoading(true)
        profileService.updateProfile(data: data, likes: likes) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.view?.displayLoading(false)
                    self?.view?.closeSave()
                case .failure:
                    self?.view?.displayLoading(false)
                    let model = self?.makeErrorModel(data: data, likes: likes)
                    if let model {
                        self?.view?.showError(model)
                    }
                }
            }
        }
    }
    
    private func makeErrorModel(data: ProfileUpdateData, likes: [String]) -> ErrorModel {
        let primary = ErrorAction(
            title: NSLocalizedString("Error.repeat", comment: ""),
            style: .default
        ) { [weak self] in
            self?.updateProfile(data: data, likes: likes)
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

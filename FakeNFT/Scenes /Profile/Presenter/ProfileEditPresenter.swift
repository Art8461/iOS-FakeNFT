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
    func didTapSave(name: String, description: String, site: String, avatar: String?)
}

final class ProfileEditPresenter: ProfileEditPresenterProtocol {
    
    weak var view: ProfileEditViewProtocol?
    private let service: ProfileServiceProtocol
    private var model: ProfileEditModel
    private var currentProfile: ProfileResponse
    
    init(
        model: ProfileEditModel,
        currentProfile: ProfileResponse,
        service: ProfileServiceProtocol
    ) {
        self.model = model
        self.currentProfile = currentProfile
        self.service = service
    }
    
    func updateModel(_ newModel: ProfileEditModel) {
        self.model = newModel
        view?.showProfile(model: model)
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
    }
    
    func didSelectDeletePhoto() {
        let updatedModel = ProfileEditModel(
            name: model.name,
            description: model.description,
            site: model.site,
            avatar: nil
        )
        
        model = updatedModel
        view?.showProfile(model: updatedModel)
        view?.enableSaveButton(true)
    }
    
    func didChangeText() {
        view?.enableSaveButton(true)
    }
    
    func didTapSave(name: String, description: String, site: String, avatar: String?) {
        let updatedModel = ProfileEditModel(
            name: name,
            description: description,
            site: site,
            avatar: avatar
        )
        model = updatedModel
        view?.enableSaveButton(false)

        service.updateProfile(updatedModel,currentProfile: currentProfile) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.currentProfile = profile
                    self?.view?.closeSave()

                case .failure:
                    self?.view?.enableSaveButton(true)
                }
            }
        }
    }
}

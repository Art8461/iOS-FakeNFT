//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 30.01.2026.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(completion: @escaping (Result<ProfileResponse, Error>) -> Void)
    
    func updateProfile(_ model: ProfileEditModel, currentProfile: ProfileResponse,
                       completion: @escaping (Result<ProfileResponse, Error>) -> Void)
    func addLike(nftId: String, completion: @escaping (Result<ProfileResponse, Error>) -> Void)
    func removeLike(nftId: String, completion: @escaping (Result<ProfileResponse, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchProfile(completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        let request = ProfileRequest()
        networkClient.send(request: request, type: ProfileResponse.self, onResponse: completion)
    }
    
    func updateProfile(
        _ model: ProfileEditModel,
        currentProfile: ProfileResponse,
        completion: @escaping (Result<ProfileResponse, Error>) -> Void
    ) {
        let dto = UpdateProfileDto(
            name: model.name,
            description: model.description,
            avatar: model.avatar ?? "",
            website: model.site,
            likes: currentProfile.likes
        )
        
        let request = UpdateProfileRequest(dtoData: dto)
        
        networkClient.send(
            request: request,
            type: ProfileResponse.self,
            onResponse: completion
        )
    }
    
    func addLike(nftId: String, completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        modifyLike(nftId: nftId, add: true, completion: completion)
    }
    
    func removeLike(nftId: String, completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        modifyLike(nftId: nftId, add: false, completion: completion)
    }
    
    private func modifyLike(
        nftId: String,
        add: Bool,
        completion: @escaping (Result<ProfileResponse, Error>) -> Void
    ) {
        fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                var likes = profile.likes
                if add {
                    if !likes.contains(nftId) { likes.append(nftId) }
                } else {
                    likes.removeAll { $0 == nftId }
                }
                let dto = UpdateProfileDto(
                    name: profile.name,
                    description: profile.description,
                    avatar: profile.avatar ?? "",
                    website: profile.website,
                    likes: likes
                )
                let request = UpdateProfileRequest(dtoData: dto)
                self.networkClient.send(request: request, type: ProfileResponse.self, onResponse: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

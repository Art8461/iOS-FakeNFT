//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 30.01.2026.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(completion: @escaping (Result<ProfileResponse, Error>) -> Void)

    func updateProfile(
        _ model: ProfileEditModel,
        currentProfile: ProfileResponse,
        completion: @escaping (Result<ProfileResponse, Error>) -> Void
    )
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
}

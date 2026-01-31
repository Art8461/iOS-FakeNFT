//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 30.01.2026.
//

typealias ProfileCompletion = (Result<ProfilUser, Error>) -> Void

protocol ProfileService {
    func loadMyProfile(completion: @escaping ProfileCompletion)
    func loadProfile(userId: String, completion: @escaping ProfileCompletion)
    func updateProfile(data: ProfileUpdateData, likes: [String], completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadMyProfile(completion: @escaping ProfileCompletion) {
        let request = ProfileRequest()
        networkClient.send(request: request, type: ProfilUser.self, onResponse: completion)
    }

    func loadProfile(userId: String, completion: @escaping ProfileCompletion) {
        let request = ProfileStatsRequest(userId: userId)
        networkClient.send(request: request, type: ProfilUser.self, onResponse: completion)
    }

    func updateProfile(data: ProfileUpdateData, likes: [String], completion: @escaping ProfileCompletion) {
        guard !data.id.isEmpty else { return }
        let dto = ProfileUpdateDto(
            name: data.name,
            description: data.description,
            avatar: data.avatar,
            website: data.website,
            likes: likes
        )
        let request = ProfileUpdateRequest(dto: dto, userId: data.id)
        networkClient.send(request: request, type: ProfilUser.self, onResponse: completion)
    }
}

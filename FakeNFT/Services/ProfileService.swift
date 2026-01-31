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
}

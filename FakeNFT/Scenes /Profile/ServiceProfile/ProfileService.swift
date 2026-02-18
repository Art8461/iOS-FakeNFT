//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 30.01.2026.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(completion: @escaping (Result<ProfileResponse, ProfileNetworkError>) -> Void)
    
    func updateProfile(
        _ model: ProfileEditModel,
        currentProfile: ProfileResponse,
        completion: @escaping (Result<ProfileResponse, ProfileNetworkError>) -> Void
    )
    
    func addLike(nftId: String,
                 completion: @escaping (Result<ProfileResponse, ProfileNetworkError>) -> Void)
    
    func removeLike(nftId: String,
                    completion: @escaping (Result<ProfileResponse, ProfileNetworkError>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Fetch Profile
    
    func fetchProfile(completion: @escaping (Result<ProfileResponse, ProfileNetworkError>) -> Void) {
        
        let request = ProfileRequest()
        Logger.shared.log("Запрос профиля...", level: .info)
        
        networkClient.send(request: request, type: ProfileResponse.self) { result in
            switch result {
            case .success(let profile):
                Logger.shared.logSuccess("Профиль загружен")
                completion(.success(profile))
                
            case .failure(let error):
                let profileError = ProfileNetworkError.network(error)
                Logger.shared.logError("Ошибка загрузки профиля: \(profileError.localizedDescription)")
                completion(.failure(profileError))
            }
        }
    }
    
    // MARK: - Update Profile
    
    func updateProfile(
        _ model: ProfileEditModel,
        currentProfile: ProfileResponse,
        completion: @escaping (Result<ProfileResponse, ProfileNetworkError>) -> Void
    ) {
        
        let dto = UpdateProfileDto(
            name: model.name,
            description: model.description,
            avatar: model.avatar ?? "",
            website: model.site,
            likes: currentProfile.likes
        )
        
        let request = UpdateProfileRequest(dtoData: dto)
        Logger.shared.log("Обновление профиля...", level: .info)
        
        networkClient.send(request: request, type: ProfileResponse.self) { result in
            switch result {
            case .success(let profile):
                Logger.shared.logSuccess("Профиль обновлён")
                completion(.success(profile))
                
            case .failure(let error):
                let profileError = ProfileNetworkError.network(error)
                Logger.shared.logError("Ошибка обновления профиля: \(profileError.localizedDescription)")
                completion(.failure(profileError))
            }
        }
    }
    
    // MARK: - Likes
    
    func addLike(nftId: String,
                 completion: @escaping (Result<ProfileResponse, ProfileNetworkError>) -> Void) {
        modifyLike(nftId: nftId, add: true, completion: completion)
    }
    
    func removeLike(nftId: String,
                    completion: @escaping (Result<ProfileResponse, ProfileNetworkError>) -> Void) {
        modifyLike(nftId: nftId, add: false, completion: completion)
    }
    
    private func modifyLike(
        nftId: String,
        add: Bool,
        completion: @escaping (Result<ProfileResponse, ProfileNetworkError>) -> Void
    ) {
        
        fetchProfile { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                
                var likes = profile.likes
                
                if add {
                    if !likes.contains(nftId) {
                        likes.append(nftId)
                    }
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
                
                Logger.shared.log(
                    "\(add ? "Добавление" : "Удаление") лайка NFT \(nftId)...",
                    level: .info
                )
                
                self.networkClient.send(request: request, type: ProfileResponse.self) { result in
                    switch result {
                    case .success(let updatedProfile):
                        Logger.shared.logSuccess("Лайк успешно \(add ? "добавлен" : "удалён")")
                        completion(.success(updatedProfile))
                        
                    case .failure(let error):
                        let profileError = ProfileNetworkError.network(error)
                        Logger.shared.logError("Ошибка изменения лайка: \(profileError.localizedDescription)")
                        completion(.failure(profileError))
                    }
                }
                
            case .failure(let error):
                let profileError = ProfileNetworkError.network(error)
                Logger.shared.logError("Ошибка получения профиля: \(profileError.localizedDescription)")
                completion(.failure(profileError))
            }
        }
    }
}

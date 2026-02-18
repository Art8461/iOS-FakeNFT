//
//  MyNFTService.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 01.02.2026.
//
import Foundation

protocol MyNFTsServiceProtocol {
    func fetchMyNFTs(
        ids: [String],
        completion: @escaping (Result<[NFTCartModel], ProfileNetworkError>) -> Void
    )
}

final class MyNFTsService: MyNFTsServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchMyNFTs(
        ids: [String],
        completion: @escaping (Result<[NFTCartModel], ProfileNetworkError>) -> Void
    ) {
        var result: [NFTCartModel] = []
        let group = DispatchGroup()
        
        Logger.shared.log("Начало загрузки NFT для ids: \(ids)", level: .info)
        
        for id in ids {
            group.enter()
            let request = MyNFTRequest(id: id)
            
            networkClient.send(request: request, type: NFTCartModel.self) { response in
                DispatchQueue.main.async {
                    switch response {
                    case .success(let nft):
                        result.append(nft)
                        Logger.shared.logSuccess("NFT \(nft.id) загружен")
                    case .failure(let error):
                        let profileError = ProfileNetworkError.network(error)
                        Logger.shared.logError("Ошибка загрузки NFT \(id): \(profileError.localizedDescription)")
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            if result.isEmpty && !ids.isEmpty {
                Logger.shared.logError("Не удалось загрузить ни один NFT")
                completion(.failure(.notFound("Нет загруженных NFT")))
            } else {
                Logger.shared.logSuccess("Загрузка NFT завершена, всего: \(result.count)")
                completion(.success(result))
            }
        }
    }
}

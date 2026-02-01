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
        completion: @escaping (Result<[NFTCartModel], Error>) -> Void
    )
}

final class MyNFTsService: MyNFTsServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchMyNFTs(
        ids: [String],
        completion: @escaping (Result<[NFTCartModel], Error>) -> Void
    ) {
        var result: [NFTCartModel] = []
        let group = DispatchGroup()

        for id in ids {
            group.enter()

            let request = MyNFTRequest(id: id)
            networkClient.send(
                request: request,
                type: NFTCartModel.self
            ) { response in
                if case let .success(nft) = response {
                    result.append(nft)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(.success(result))
        }
    }
}

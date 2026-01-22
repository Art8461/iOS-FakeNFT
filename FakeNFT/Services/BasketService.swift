//
//  BasketService.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 22.01.2026.
//

typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol BasketService {
    func loadOrder(completion: @escaping OrderCompletion)
    func updateOrder(nfts: [String], completion: @escaping OrderCompletion)
}

final class BasketServiceImpl: BasketService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadOrder(completion: @escaping OrderCompletion) {
        networkClient.send(request: OrderRequest(), type: Order.self, onResponse: completion)
    }
    
    func updateOrder(nfts: [String], completion: @escaping OrderCompletion) {
        let dto = UpdateOrderDto(nfts: nfts)
        let request = UpdateOrderRequest(dto: dto)
        networkClient.send(request: request, type: Order.self, onResponse: completion)
    }
}

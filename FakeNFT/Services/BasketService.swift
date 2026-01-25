//
//  BasketService.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 22.01.2026.
//

typealias OrderCompletion = (Result<Order, Error>) -> Void
typealias CompleteOrderCompletion = (Result<Void, Error>) -> Void

protocol BasketService {
    func loadOrder(completion: @escaping OrderCompletion)
    func updateOrder(nfts: [String], completion: @escaping OrderCompletion)
    func completeOrder(orderId: String, completion: @escaping CompleteOrderCompletion)
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
    
    func completeOrder(orderId: String, completion: @escaping CompleteOrderCompletion) {
        let dto = CompleteOrderDto(id: orderId, nfts: [])
        let request = CompleteOrderRequest(dto: dto) // URL остаётся /orders/1
        networkClient.send(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

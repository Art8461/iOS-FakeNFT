//
//  CurrenciesService.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 25.01.2026.
//

typealias CurrenciesCompletion = (Result<[Currency], Error>) -> Void

protocol CurrenciesService {
    func loadCurrencies(completion: @escaping CurrenciesCompletion)
}

final class CurrenciesServiceImpl: CurrenciesService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCurrencies(completion: @escaping CurrenciesCompletion) {
        networkClient.send(request: CurrenciesRequest(), type: [Currency].self, onResponse: completion)
    }
}

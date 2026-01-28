//
//  PaymentService.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 25.01.2026.
//

typealias PaymentCompletion = (Result<PaymentResponse, Error>) -> Void

protocol PaymentService {
    func payOrder(currencyId: String, completion: @escaping PaymentCompletion)
}

final class PaymentServiceImpl: PaymentService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func payOrder(currencyId: String, completion: @escaping PaymentCompletion) {
        let request = PaymentRequest(currencyId: currencyId)
        networkClient.send(request: request, type: PaymentResponse.self, onResponse: completion)
    }
}

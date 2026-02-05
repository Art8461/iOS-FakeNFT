//
//  BasketAssembly.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 26.01.2026.
//

import UIKit

final class BasketAssembly {
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build() -> UIViewController {
        let paymentAssembly = PaymentAssembly(servicesAssembly: servicesAssembly)
        let router = BasketRouter(paymentAssembly: paymentAssembly)

        let presenter = BasketPresenterImpl(
            basketService: servicesAssembly.basketService,
            nftService: servicesAssembly.nftService,
            router: router
        )

        let vc = BasketViewController(presenter: presenter)
        presenter.view = vc
        router.viewController = vc
        return vc
    }
}

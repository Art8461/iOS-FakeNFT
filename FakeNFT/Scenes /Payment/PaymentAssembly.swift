//
//  PaymentAssembly.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 26.01.2026.
//

import UIKit

final class PaymentAssembly {
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build(orderId: String) -> UIViewController {
        let presenter = PaymentPresenterImpl(
            currencyService: servicesAssembly.currenciesService,
            paymentService: servicesAssembly.paymentService,
            basketService: servicesAssembly.basketService,
            orderId: orderId
        )
        let vc = PaymentViewController(presenter: presenter)
        presenter.view = vc
        vc.title = NSLocalizedString("Выберите способ оплаты", comment: "payment title")
        return vc
    }
}

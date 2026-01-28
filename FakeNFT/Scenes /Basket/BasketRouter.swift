//
//  BasketRouter.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 26.01.2026.
//

import UIKit

protocol BasketRouting {
    func showPayment(orderId: String)
}

final class BasketRouter: BasketRouting {
    weak var viewController: UIViewController?
    private let paymentAssembly: PaymentAssembly

    init(paymentAssembly: PaymentAssembly) {
        self.paymentAssembly = paymentAssembly
    }

    func showPayment(orderId: String) {
        let vc = paymentAssembly.build(orderId: orderId)
        vc.hidesBottomBarWhenPushed = true
        if let nav = viewController?.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            viewController?.present(UINavigationController(rootViewController: vc), animated: true)
        }
    }
}

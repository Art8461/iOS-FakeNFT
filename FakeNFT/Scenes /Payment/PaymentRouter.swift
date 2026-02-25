//
//  PaymentRouter.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 26.01.2026.
//

import UIKit

protocol PaymentRouting {
    func showUserAgreement(url: URL)
    func showPaymentSuccess(onReturn: @escaping () -> Void)
    func returnToBasket()
    func close()
}

final class PaymentRouter: PaymentRouting {
    weak var viewController: UIViewController?

    func showUserAgreement(url: URL) {
        let vc = WebViewPayment(url: url)
        vc.title = NSLocalizedString("Пользовательское соглашение", comment: "title user agreement")
        if let nav = viewController?.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            viewController?.present(UINavigationController(rootViewController: vc), animated: true)
        }
    }

    func showPaymentSuccess(onReturn: @escaping () -> Void) {
        let vc = PaymentSuccessViewController()
        vc.onReturnToBasket = onReturn
        if let nav = viewController?.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            viewController?.present(UINavigationController(rootViewController: vc), animated: true)
        }
    }

    func returnToBasket() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }

    func close() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

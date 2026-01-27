//
//  AuthRouter.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 26.01.2026.
//

import UIKit

protocol AuthRouting {
    func showMain()
    func showSignUp()
    func showPasswordReset()
}

final class AuthRouter: AuthRouting {
    weak var viewController: UIViewController?
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func showMain() {
        let tabBarController = TabBarController(servicesAssembly: servicesAssembly)
        guard let window = resolveWindow() else { return }

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = tabBarController
        }
    }

    func showSignUp() {
        let presenter = AuthPresenterImpl(
            authService: servicesAssembly.authService,
            router: self,
            initialMode: .signUp
        )
        let signUpViewController = AuthViewController(presenter: presenter, hidesNavigationBar: false)
        presenter.view = signUpViewController

        if let navigationController = viewController?.navigationController {
            navigationController.pushViewController(signUpViewController, animated: true)
        } else {
            viewController?.present(signUpViewController, animated: true)
        }
    }

    func showPasswordReset() {
        let presenter = ResetPasswordPresenterImpl(authService: servicesAssembly.authService)
        let viewController = ResetPasswordViewController(presenter: presenter)
        presenter.view = viewController
        if let navigationController = self.viewController?.navigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            self.viewController?.present(viewController, animated: true)
        }
    }

    private func resolveWindow() -> UIWindow? {
        if let window = viewController?.view.window {
            return window
        }
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

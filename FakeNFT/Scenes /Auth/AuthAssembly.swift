//
//  AuthAssembly.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 26.01.2026.
//

import UIKit

final class AuthAssembly {
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build() -> UIViewController {
        let router = AuthRouter(servicesAssembly: servicesAssembly)
        let presenter = AuthPresenterImpl(
            authService: servicesAssembly.authService,
            router: router,
            initialMode: .signIn
        )
        let vc = AuthViewController(presenter: presenter, hidesNavigationBar: true)
        presenter.view = vc
        router.viewController = vc

        let navigation = UINavigationController(rootViewController: vc)
        return navigation
    }
}

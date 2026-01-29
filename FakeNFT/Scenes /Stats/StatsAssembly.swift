//
//  StatsAssembly.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 28.01.2026.
//

import UIKit

final class StatsAssembly {
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    func build() -> UIViewController {
        let profileAssembly = ProfileAssembly(servicesAssembly: servicesAssembly)
        let router = StatsRouter(profileAssembly: profileAssembly)

        let presenter = StatsPresenterImpl(
            usersService: servicesAssembly.usersService,
            router: router
        )

        let vc = StatsViewController(presenter: presenter)
        presenter.view = vc
        router.viewController = vc
        return vc
    }
}

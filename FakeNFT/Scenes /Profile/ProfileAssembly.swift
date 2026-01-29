//
//  ProfileAssembly.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 29.01.2026.
//

import UIKit

final class ProfileAssembly {
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build(mode: ProfileMode) -> UIViewController {
        let presenter = ProfilePresenter(mode: mode)
        let vc = ProfileViewController(servicesAssembly: servicesAssembly, presenter: presenter)
        presenter.view = vc
        return vc
    }
}

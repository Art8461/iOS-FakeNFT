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
        let vc = StatsViewController(servicesAssembly: servicesAssembly)
        return vc
    }
}

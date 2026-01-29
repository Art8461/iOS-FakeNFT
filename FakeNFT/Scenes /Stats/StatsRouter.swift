//
//  StatsRouter.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 29.01.2026.
//

import UIKit

protocol StatsRouting {
    func showProfile(userId: String)
}

final class StatsRouter: StatsRouting {
    weak var viewController: UIViewController?
    private let profileAssembly: ProfileAssembly

    init(profileAssembly: ProfileAssembly) {
        self.profileAssembly = profileAssembly
    }

    func showProfile(userId: String) {
        let vc = profileAssembly.build(mode: .user(id: userId))
        vc.hidesBottomBarWhenPushed = true

        if let nav = viewController?.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            viewController?.present(UINavigationController(rootViewController: vc), animated: true)
        }
    }
}

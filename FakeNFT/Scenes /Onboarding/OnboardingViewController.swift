//
//  OnboardingViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 27.01.2026.
//

import UIKit

final class OnboardingViewController: UIViewController {
    var onFinish: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .whiteApp)
    }
}

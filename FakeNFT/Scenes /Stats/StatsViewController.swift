//
//  StatsViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 21.01.2026.
//

import UIKit

final class StatsViewController: UIViewController, ErrorView {
    private enum Constants {
        static let buttonInset: CGFloat = 16
        static let buttonHeight: CGFloat = 44
    }

    let servicesAssembly: ServicesAssembly

    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Выйти", comment: "sign out button"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blackApp
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        return button
    }()

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Статистика", comment: "statistics screen title")
        view.backgroundColor = .whiteApp
        setupLayout()
    }

    @objc
    private func signOutTapped() {
        do {
            try servicesAssembly.authService.signOut()
            showAuth()
        } catch {
            showSignOutError()
        }
    }

    private func setupLayout() {
        view.addSubview(signOutButton)

        NSLayoutConstraint.activate([
            signOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.buttonInset),
            signOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.buttonInset),
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.buttonInset),
            signOutButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }

    private func showAuth() {
        let authViewController = AuthAssembly(servicesAssembly: servicesAssembly).build()
        guard let window = resolveWindow() else { return }

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = authViewController
        }
    }

    private func showSignOutError() {
        let primary = ErrorAction(
            title: NSLocalizedString("Error.close", comment: ""),
            style: .cancel
        ) { }
        let model = ErrorModel(
            message: NSLocalizedString("Error.unknown", comment: ""),
            primaryAction: primary,
            secondaryAction: nil
        )
        showError(model)
    }

    private func resolveWindow() -> UIWindow? {
        if let window = view.window {
            return window
        }
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

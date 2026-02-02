//
//  CollectionNFTViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 02.02.2026.
//

import UIKit

protocol CollectionNFTViewProtocol: AnyObject {
    func closeScreen()
}

final class CollectionNFTViewController: UIViewController {
    private let presenter: CollectionNFTPresenterProtocol

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Коллекция NFT"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .blackApp
        return label
    }()

    init(presenter: CollectionNFTPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteApp
        setupNavigationBar()
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        presenter.viewDidLoad()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Коллекция NFT"
        navigationItem.leftBarButtonItem = .backButton(
            target: self,
            action: #selector(tapBackButton)
        )
    }

    @objc private func tapBackButton() {
        presenter.didTapBack()
    }
}

extension CollectionNFTViewController: CollectionNFTViewProtocol {
    func closeScreen() {
        navigationController?.popViewController(animated: true)
    }
}

//
//  PaymentSuccessViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 24.01.2026.
//

import UIKit

final class PaymentSuccessViewController: UIViewController {
    
    var onReturnToBasket: (() -> Void)?
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .placeholderpayment)
        imageView.tintColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Успех! Оплата прошла,\nпоздравляем с покупкой!", comment: "payment success text")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(resource: .blackApp)
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Вернуться в корзину", comment: "return to basket button"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor(resource: .blackApp)
        button.setTitleColor(UIColor(resource: .whiteApp), for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [placeholderImageView, messageLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .whiteApp)
        setupLayout()
        returnButton.addTarget(self, action: #selector(didTapReturnToBasket), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupLayout() {
        view.addSubview(contentStack)
        view.addSubview(returnButton)
        
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            contentStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: returnButton.topAnchor, constant: -24),
            
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            placeholderImageView.widthAnchor.constraint(equalToConstant: 278),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 278)
        ])
    }
    
    @objc private func didTapReturnToBasket() {
        onReturnToBasket?()
    }
}

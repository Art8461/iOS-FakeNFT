//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 24.01.2026.
//

import UIKit

final class PaymentViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = Self.makeCurrencyLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = self
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .lightGreyApp)
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var agreementTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Совершая покупку, вы соглашаетесь с условиями" , comment: "")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(resource: .blackApp)
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var userAgreementButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let title = NSLocalizedString("Пользовательского соглашения", comment: "")
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular),
            .foregroundColor: UIColor(resource: .blueUniversal),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attrs), for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Оплатить", comment: ""), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor(resource: .blackApp)
        button.setTitleColor(UIColor(resource: .whiteApp), for: .normal)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()
    
    private lazy var bottomTextStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            agreementTextLabel,
            userAgreementButton,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            bottomTextStack,
            payButton
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private static func makeCurrencyLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, env in
            let contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 8, trailing: 16)
            let interItemSpacing: CGFloat = 7
            let columns: CGFloat = 2
            
            let availableWidth = env.container.effectiveContentSize.width - contentInsets.leading - contentInsets.trailing - interItemSpacing
            
            let itemWidth = floor(availableWidth / columns)
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .absolute(46)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(46)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
            group.interItemSpacing = .fixed(interItemSpacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = contentInsets
            section.interGroupSpacing = 7
            
            return section
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CurrencyCell.self)

        view.backgroundColor = .systemBackground
        setupLayout()
        userAgreementButton.addTarget(self, action: #selector(openUserAgreement), for: .touchUpInside)
    }
    private func setupLayout(){
        
        view.addSubview(collectionView)
        view.addSubview(containerView)
        containerView.addSubview(bottomStack)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.topAnchor),
        ])
    
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            bottomStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            bottomStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            bottomStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            bottomStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func openUserAgreement() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse") else { return }
        let vc = WebViewController(url: url)
        vc.title = NSLocalizedString("Пользовательское соглашение", comment: "")

        if let nav = navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            present(UINavigationController(rootViewController: vc), animated: true)
        }
    }
}

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}

//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 24.01.2026.
//

import UIKit

final class PaymentViewController: UIViewController {
    
    private let presenter: PaymentPresenter
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    init(presenter: PaymentPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cellModels: [CurrencyCellModel] = []

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
            let contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 8, trailing: 0)
            let columns: CGFloat = 2
            
            let availableWidth = env.container.effectiveContentSize.width - contentInsets.leading - contentInsets.trailing
            
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
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = contentInsets
            section.interGroupSpacing = 7
            
            return section
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureNavigationBar()

        collectionView.delegate = self
        userAgreementButton.addTarget(self, action: #selector(didTapUserAgreement), for: .touchUpInside)
        payButton.addTarget(self, action: #selector(didTapPay), for: .touchUpInside)
        collectionView.register(CurrencyCell.self)
        setupLayout()
        presenter.viewDidLoad()
    }
    
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        let image = UIImage(resource: .backward).withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapBack))
        backButton.tintColor = UIColor(resource: .blackApp)
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupLayout(){
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
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
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            bottomStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            bottomStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            bottomStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func didTapBack() {
        presenter.didTapBack()
    }

    @objc private func didTapUserAgreement() {
        presenter.didTapUserAgreement()
    }

    @objc private func didTapPay() {
        presenter.didTapPay()
    }
}

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CurrencyCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(with: cellModels[indexPath.item])
        return cell
    }
}

extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectCurrency(at: indexPath.item)
    }
}

extension PaymentViewController: PaymentView {

    func displayLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func display(currencies: [CurrencyCellModel]) {
        cellModels = currencies
        collectionView.reloadData()
    }

    func setPayEnabled(_ isEnabled: Bool) {
        payButton.isEnabled = isEnabled
        payButton.alpha = isEnabled ? 1.0 : 0.5
    }
}

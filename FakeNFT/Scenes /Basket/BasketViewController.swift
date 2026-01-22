//
//  BasketController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 21.01.2026.
//

import UIKit

final class BasketViewController: UIViewController {
    
    private let presenter: BasketPresenter

    init(presenter: BasketPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Корзина пуста" , comment: "basket is empty state")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(resource: .blackApp)
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: UIImage(resource: .sort),
            style: .plain,
            target: self,
            action: #selector(didTapSort)
        )
        item.tintColor = UIColor(resource: .blackApp)
        return item
    }()

    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = self
        return view
    }()
    
    private let summaryContainer = UIView()
    private let summaryLeftStack = UIStackView()
    private let countLabel = UILabel()
    private let totalLabel = UILabel()
    private let payButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupSummary()
        setupLayout()
        presenter.viewDidLoad()
    }
    
    private func setupLayout() {
        view.addSubview(emptyStateLabel)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: summaryContainer.topAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        summaryContainer.translatesAutoresizingMaskIntoConstraints = false
        summaryLeftStack.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        payButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            summaryContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            summaryContainer.heightAnchor.constraint(equalToConstant: 76),
            
            summaryLeftStack.leadingAnchor.constraint(equalTo: summaryContainer.leadingAnchor, constant: 16),
            summaryLeftStack.centerYAnchor.constraint(equalTo: summaryContainer.centerYAnchor),
            
            payButton.leadingAnchor.constraint(equalTo: summaryLeftStack.trailingAnchor, constant: 24),
            payButton.trailingAnchor.constraint(equalTo: summaryContainer.trailingAnchor, constant: -16),
            payButton.centerYAnchor.constraint(equalTo: summaryContainer.centerYAnchor),
            payButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupSummary() {
        summaryContainer.backgroundColor = UIColor(resource: .lightGreyApp)
        summaryContainer.layer.cornerRadius = 12
        summaryContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        summaryContainer.layer.masksToBounds = true
        
        summaryLeftStack.axis = .vertical
        summaryLeftStack.spacing = 2
        
        countLabel.font = .systemFont(ofSize: 15)
        countLabel.textColor = UIColor(resource: .blackApp)
        totalLabel.font = .systemFont(ofSize: 17, weight: .bold)
        totalLabel.textColor = UIColor(resource: .greenUniversal)
        
        payButton.backgroundColor = UIColor(resource: .blackApp)
        payButton.setTitleColor(UIColor(resource: .whiteApp), for: .normal)
        payButton.layer.cornerRadius = 16
        payButton.clipsToBounds = true
        payButton.setTitle(NSLocalizedString("К оплате", comment: "button for pay"), for: .normal)
        payButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        
        summaryContainer.addSubview(summaryLeftStack)
        summaryLeftStack.addArrangedSubview(countLabel)
        summaryLeftStack.addArrangedSubview(totalLabel)
        summaryContainer.addSubview(payButton)
        view.addSubview(summaryContainer)
    }

    private func updateEmptyState(isEmpty: Bool) {
        emptyStateLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
        summaryContainer.isHidden = isEmpty
        navigationItem.rightBarButtonItem = isEmpty ? nil : sortButton
    }
    
    @objc
    private func didTapSort() {
        presenter.didTapSort()
        // TODO: сортировка позже
    }
}

extension BasketViewController: BasketView {
    func display(isEmpty: Bool) {
        updateEmptyState(isEmpty: isEmpty)
    }
    
}

extension BasketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}

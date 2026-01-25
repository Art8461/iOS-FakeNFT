//
//  BasketController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 21.01.2026.
//

import UIKit

final class BasketViewController: UIViewController {
    
    private let presenter: BasketPresenter
    private let servicesAssembly: ServicesAssembly

    init(presenter: BasketPresenter, servicesAssembly: ServicesAssembly) {
        self.presenter = presenter
        self.servicesAssembly = servicesAssembly
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
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let summaryContainer = UIView()
    private let summaryLeftStack = UIStackView()
    private let countLabel = UILabel()
    private let totalLabel = UILabel()
    private let payButton = UIButton(type: .system)
    
    private var cellModels: [BasketItemCellModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(BasketItemCell.self)

        view.backgroundColor = .systemBackground
        setupNavigation()
        setupSummary()
        setupLayout()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.refresh()
    }
    
    private func setupLayout() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.hidesWhenStopped = true
        
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
        payButton.addTarget(self, action: #selector(didTapPay), for: .touchUpInside)
        
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
    
    private func presentDeleteConfirmation(for model: BasketItemCellModel) {
        let vc = BasketDeleteConfirmationViewController()
        vc.imageURL = model.imageURL
        vc.onDelete = { [weak self, weak vc] in
            vc?.dismiss(animated: true)
            self?.presenter.didTapDelete(id: model.id)
        }
        vc.onCancel = { [weak vc] in
            vc?.dismiss(animated: true)
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @objc
    private func didTapSort() {
        let controller = UIAlertController(
            title: NSLocalizedString("Сортировка", comment: "sort action sheet title"),
            message: nil,
            preferredStyle: .actionSheet
        )
        let sortByPrice = UIAlertAction(
            title: NSLocalizedString("По цене", comment: "sort by price"),
            style: .default
        ) { [weak self] _ in
            self?.presenter.didSelectSort(option: .price)
        }
        let sortByRating = UIAlertAction(
            title: NSLocalizedString("По рейтингу", comment: "sort by rating"),
            style: .default
        ) { [weak self] _ in
            self?.presenter.didSelectSort(option: .rating)
        }
        let sortByName = UIAlertAction(
            title: NSLocalizedString("По названию", comment: "sort by name"),
            style: .default
        ) { [weak self] _ in
            self?.presenter.didSelectSort(option: .name)
        }
        let cancel = UIAlertAction(
            title: NSLocalizedString("Закрыть", comment: "cancel sort"),
            style: .cancel
        )
        
        controller.addAction(sortByPrice)
        controller.addAction(sortByRating)
        controller.addAction(sortByName)
        controller.addAction(cancel)
        
        if let popover = controller.popoverPresentationController {
            popover.barButtonItem = sortButton
        }
        present(controller, animated: true)
    }
    
    @objc private func didTapPay() {
        let presenter = PaymentPresenterImpl(currencyService: servicesAssembly.currenciesService)
        let vc = PaymentViewController(presenter: presenter)
        presenter.view = vc
        vc.title = NSLocalizedString("Выберите способ оплаты", comment: "payment title")

        if let nav = navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            present(UINavigationController(rootViewController: vc), animated: true)
        }
    }
}

extension BasketViewController: BasketView {
    
    func displayLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            navigationItem.rightBarButtonItem = nil
            summaryContainer.isHidden = true
            collectionView.isHidden = true
            emptyStateLabel.isHidden = true
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func display(items: [BasketItemCellModel]) {
        cellModels = items
        collectionView.reloadData()
    }
    
    func display(isEmpty: Bool) {
        updateEmptyState(isEmpty: isEmpty)
    }
    
    func display(summary: BasketSummaryViewModel) {
        countLabel.text = summary.countText
        totalLabel.text = summary.totalText
    }
}

extension BasketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BasketItemCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let model = cellModels[indexPath.row]
        cell.configure(with: model)
        cell.onDelete = { [weak self] in
            self?.presentDeleteConfirmation(for: model)
        }
        return cell
    }
}

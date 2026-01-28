//
//  StatsViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 21.01.2026.
//

import UIKit

final class StatsViewController: UIViewController {
    
    private let presenter: StatsPresenter
    
    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = .clear
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = self
        return view
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var cellModels: [StatsItemCellModel] = []
    
    init(presenter: StatsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(StatsItemCell.self)
        view.backgroundColor = UIColor(resource: .whiteApp)
        setupNavigation()
        setupLayout()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.refresh()
    }
    
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = sortActionSheet.barButtonItem
    }
    
    private func setupLayout() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private lazy var sortActionSheet = SortActionSheetViewController(
        presentingViewController: self,
        options: [
            SortActionSheetOption(
                title: NSLocalizedString("По рейтингу", comment: "sort by rating"),
                handler: { [weak self] in
                    self?.presenter.didSelectSort(option: .rating)
                }
            ),
            SortActionSheetOption(
                title: NSLocalizedString("По имени", comment: "sort by name"),
                handler: { [weak self] in
                    self?.presenter.didSelectSort(option: .name)
                }
            )
        ]
    )
}

extension StatsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StatsItemCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.backgroundColor = .clear
        cell.configure(with: cellModels[indexPath.row])
        return cell
    }
}

extension StatsViewController: StatsView {
    func display(items: [StatsItemCellModel]) {
        cellModels = items
        collectionView.reloadData()
    }
    
    func displayLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            collectionView.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            collectionView.isHidden = false
        }
    }
}

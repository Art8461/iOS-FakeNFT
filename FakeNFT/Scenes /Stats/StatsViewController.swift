//
//  StatsViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 21.01.2026.
//

import UIKit

final class StatsViewController: UIViewController {
    
    let servicesAssembly: ServicesAssembly
    
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
        config.backgroundColor = .clear
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.dataSource = self
        return view
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
        view.backgroundColor = UIColor(resource: .whiteApp)
        setupNavigation()
        setupLayout()
    }
    
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func didTapSort() {
        let controller = UIAlertController(
            title: NSLocalizedString("Сортировка", comment: "sort action sheet title"),
            message: nil,
            preferredStyle: .actionSheet
        )
        let sortByRating = UIAlertAction(
            title: NSLocalizedString("По рейтингу", comment: "sort by rating"),
            style: .default,
            handler: nil
        )
        let sortByName = UIAlertAction(
            title: NSLocalizedString("По имени", comment: "sort by name"),
            style: .default,
            handler: nil
        )
        let cancel = UIAlertAction(
            title: NSLocalizedString("Закрыть", comment: "cancel sort"),
            style: .cancel
        )
        
        controller.addAction(sortByRating)
        controller.addAction(sortByName)
        controller.addAction(cancel)
        
        if let popover = controller.popoverPresentationController {
            popover.barButtonItem = sortButton
        }
        present(controller, animated: true)
    }
}

extension StatsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}

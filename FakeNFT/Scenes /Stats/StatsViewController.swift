//
//  StatsViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 21.01.2026.
//

import UIKit

final class StatsViewController: UIViewController {
    
    let servicesAssembly: ServicesAssembly
    
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
        navigationItem.rightBarButtonItem = sortActionSheet.barButtonItem
    }
    
    private func setupLayout() {
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
                title: NSLocalizedString("По имени", comment: "sort by name"),
                handler: { }
            ),
            SortActionSheetOption(
                title: NSLocalizedString("По рейтингу", comment: "sort by rating"),
                handler: { }
            )
        ]
    )
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

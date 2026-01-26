//
//  FavoritesNFTViewController.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 24.01.2026.
//

import UIKit

protocol FavoritesNFTViewProtocol: AnyObject {
    func closeScreen()
}


final class FavoritesNFTViewController: UIViewController {
    
    private let presenter: FavoritesNFTPresenterProtocol
    
    var myFavoritesNFT: [NFTCartModel] = []
    
    
    init(presenter: FavoritesNFTPresenterProtocol) {
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
        addSubviews()
        setupConstraints()
        setupMocks()
        updateUI()
    }
    
    private lazy var emptyFavoritesLabel =
    UILabel.emptyStateLabel(text: "У Вас еще нет избранных NFT")
    
    private lazy var favoritesNFTCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .whiteApp
        collection.register(FavoritesNFTCell.self, forCellWithReuseIdentifier: FavoritesNFTCell.reuseIdentifier)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    
    private func setupNavigationBar() {
        setupBaseNavigationBar()
        navigationItem.leftBarButtonItem = .backButton(target: self, action: #selector(tapBackButton))
    }
    
    private func addSubviews() {
        [emptyFavoritesLabel, favoritesNFTCollection].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        [emptyFavoritesLabel, favoritesNFTCollection].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            emptyFavoritesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyFavoritesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            favoritesNFTCollection.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            favoritesNFTCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoritesNFTCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoritesNFTCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func tapBackButton(){
        presenter.didTapBack()
        print("назад на главный экран")
    }
    
    func setupMocks() {
        myFavoritesNFT = NFTMockData.favoriteNFTs()
        favoritesNFTCollection.reloadData()
    }
    
    private func updateUI() {
        let isEmpty = myFavoritesNFT.isEmpty
        emptyFavoritesLabel.isHidden = !isEmpty
        favoritesNFTCollection.isHidden = isEmpty
        
        navigationItem.title = isEmpty ? nil : "Избранные NFT"
        
    }
    
}

extension FavoritesNFTViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myFavoritesNFT.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesNFTCell.reuseIdentifier,
            for: indexPath) as? FavoritesNFTCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: myFavoritesNFT[indexPath.item])
        return cell
    }
}

extension FavoritesNFTViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 7
        let availableWidth =
        collectionView.bounds.width - spacing
        let width = availableWidth / 2
        
        return CGSize(width: width, height: 80)
    }
}

extension FavoritesNFTViewController: FavoritesNFTViewProtocol {
    func closeScreen() {
        navigationController?.popViewController(animated: true)
    }
    
}

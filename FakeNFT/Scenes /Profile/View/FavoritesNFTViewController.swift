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
    
    var myFavoritesNFT: [String] = []
    
    
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
        updateUI()
    }
    
    private lazy var emptyFavoritesLabel =
    UILabel.emptyStateLabel(text: "У Вас еще нет избранных NFT")
    
    private lazy var favoritesNFTCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .whiteApp
        collection.register(FavoritesNFTCell.self, forCellWithReuseIdentifier: FavoritesNFTCell.reuseIdentifier)
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
            emptyFavoritesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    
    @objc func tapBackButton(){
        presenter.didTapBack()
        print("назад на главный экран")
    }
    
    private func updateUI() {
        let isEmpty = myFavoritesNFT.isEmpty
        emptyFavoritesLabel.isHidden = !isEmpty
        favoritesNFTCollection.isHidden = isEmpty
        
        navigationItem.title = isEmpty ? nil : "Избранные NFT"
        
    }
    
}

extension FavoritesNFTViewController: FavoritesNFTViewProtocol {
    func closeScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    
}

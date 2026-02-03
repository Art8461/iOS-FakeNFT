//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 23.01.2026.
//

import UIKit

// MARK: - Protocols

protocol MyNFTsViewProtocol: AnyObject {
    func closeScreen()
    func showSortAlert(options: [Sorting])
    func showNFTs(_ nfts: [NFTCartModel], likedIds: [String])
}

// MARK: - MyNFTsViewController

final class MyNFTsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: MyNFTsPresenterProtocol
    private var myNFTs: [NFTCartModel] = []
    private var likedNFTIds: [String] = []
    
    // MARK: - UI
    
    private lazy var emptyNFTLabel =
    UILabel.emptyStateLabel(text: "У Вас еще нет NFT")
    
    private lazy var loader = UIActivityIndicatorView.baseLoader()
    
    private lazy var myNFTTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyNFTCell.self, forCellReuseIdentifier: "MyNFTCell")
        tableView.backgroundColor = .whiteApp
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Initializers
    
    init(presenter: MyNFTsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteApp
        setupNavigationBar()
        addSubviews()
        setupConstraints()
        showLoading(true)
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        setupBaseNavigationBar()
        navigationItem.leftBarButtonItem = .backButton(
            target: self,
            action: #selector(tapBackButton)
        )
        navigationItem.rightBarButtonItem = .sortButton(
            target: self,
            action: #selector(tapSortButton)
        )
    }
    
    private func addSubviews() {
        [emptyNFTLabel, myNFTTableView, loader].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        [emptyNFTLabel, myNFTTableView, loader].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            emptyNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            myNFTTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            myNFTTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNFTTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myNFTTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func showLoading(_ isLoading: Bool) {
        loader.isHidden = !isLoading
        if isLoading {
            loader.startAnimating()
            myNFTTableView.isHidden = true
            emptyNFTLabel.isHidden = true
        } else {
            loader.stopAnimating()
        }
    }
    
    // MARK: - Actions
    
    @objc private func tapBackButton() {
        presenter.didTapBack()
        print("назад на главный экран")
    }
    
    @objc private func tapSortButton() {
        presenter.didTapSort()
        print("сортировка")
    }
    
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension MyNFTsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myNFTs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyNFTCell.reuseIdentifier,
            for: indexPath
        ) as? MyNFTCell else {
            return UITableViewCell()
        }
        
        let nft = myNFTs[indexPath.row]
        cell.configure(with: nft, likedIds: likedNFTIds) { [weak self] in
            self?.presenter.didTapLike(nftId: nft.id)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

// MARK: - MyNFTsViewProtocol

extension MyNFTsViewController: MyNFTsViewProtocol {
    
    func closeScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    func showSortAlert(options: [Sorting]) {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        for option in options {
            alert.addAction(UIAlertAction(title: option.title, style: .default) { [weak self] _ in
                self?.presenter.didSelectSortOption(option)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func showNFTs(_ nfts: [NFTCartModel], likedIds: [String]) {
        showLoading(false)
        self.myNFTs = nfts
        self.likedNFTIds = likedIds
        myNFTTableView.reloadData()
        
        let isEmpty = myNFTs.isEmpty
        emptyNFTLabel.isHidden = !isEmpty
        myNFTTableView.isHidden = isEmpty
        
        navigationItem.title = isEmpty ? nil : "Мои NFT"
        navigationItem.rightBarButtonItem = isEmpty
        ? nil
        : .sortButton(target: self, action: #selector(tapSortButton))
    }
    
}

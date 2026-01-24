//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 23.01.2026.
//

import UIKit

protocol MyNFTsViewProtocol: AnyObject {
    func closeScreen()
}


final class MyNFTsViewController: UIViewController {
    
    private let presenter: MyNFTsPresenterProtocol
    
    var myNFTs: [String] = []
    
    init(presenter: MyNFTsPresenterProtocol) {
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
    
    private lazy var emptyNFTLabel =
        UILabel.emptyStateLabel(text: "У Вас еще нет NFT")
    
    private lazy var myNFTTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyNFTCell.self, forCellReuseIdentifier: "MyNFTCell")
        tableView.backgroundColor = .whiteApp
        return tableView
    }()
    
    private func setupNavigationBar() {
        setupBaseNavigationBar()
        navigationItem.leftBarButtonItem = .backButton(target: self, action: #selector(tapBackButton))
        navigationItem.rightBarButtonItem = .sortButton(target: self, action: #selector(tapSortButton))
    }
    
    private func addSubviews() {
        [emptyNFTLabel, myNFTTableView].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        [emptyNFTLabel, myNFTTableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            emptyNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
            
    }
    
    private func updateUI() {
        let isEmpty = myNFTs.isEmpty
        emptyNFTLabel.isHidden = !isEmpty
        myNFTTableView.isHidden = isEmpty
        
        navigationItem.title = isEmpty ? nil : "Мои NFT"
        navigationItem.rightBarButtonItem = isEmpty ? nil : .sortButton(target: self, action: #selector(tapSortButton))

    }
    
    @objc func tapBackButton(){
        presenter.didTapBack()
        print("назад на главный экран")
    }
    
    @objc func tapSortButton(){
        print("сортировка")
    }
}

extension MyNFTsViewController: MyNFTsViewProtocol {
    func closeScreen() {
        navigationController?.popViewController(animated: true)
    }
}

//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 21.01.2026.
//

import UIKit
import Kingfisher

// MARK: - Protocols

protocol ProfileViewProtocol: AnyObject {
    func updateProfile(_ profile: ProfileResponse)
}

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: ProfilePresenterProtocol
    private var profile: ProfileResponse?
    
    private var profileCellName: [ProfileItem] = [
        ProfileItem(type: .myNFT, count: 0),
        ProfileItem(type: .myFavorites, count: 0)
    ]
    
    // MARK: - UI
    
    private lazy var loader = UIActivityIndicatorView.baseLoader()
    
    private lazy var editButton: UIBarButtonItem = {
        let image = UIImage(resource: .squareAndPencil)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(tapEditButton))
        button.tintColor = .blackApp
        return button
    }()
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView.baseAvatarImage()
        return image
    }()
    
    private lazy var avatarName: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .blackApp
        return label
    }()
    
    private lazy var personStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImage, avatarName])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 16
        return stack
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.textColor = .blackApp
        
        return label
    }()
    
    private lazy var webSiteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .blueUniversal
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapWebSiteLabel))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private lazy var bigStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [personStack, descriptionLabel, webSiteLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.setCustomSpacing(20, after: personStack)
        stack.setCustomSpacing(8, after: descriptionLabel)
        return stack
    }()
    
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .whiteApp
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // MARK: - Initializers
    
    init(presenter: ProfilePresenterProtocol) {
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
        navigationItem.title = nil
        showLoading(true)
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading(true)
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = editButton
    }
    
    private func addSubviews() {
        [loader, bigStack, profileTableView].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        [loader, bigStack, profileTableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            bigStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            bigStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bigStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            personStack.topAnchor.constraint(equalTo: bigStack.topAnchor),
            personStack.leadingAnchor.constraint(equalTo: bigStack.leadingAnchor),
            personStack.trailingAnchor.constraint(equalTo: bigStack.trailingAnchor),
            personStack.heightAnchor.constraint(equalToConstant: 70),
            
            profileTableView.topAnchor.constraint(equalTo: bigStack.bottomAnchor, constant: 40),
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func showAvatar(_ avatar: String?) {
        if let avatar = avatar,
           !avatar.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           let url = URL(string: avatar) {
            avatarImage.kf.setImage(
                with: url,
                placeholder: UIImage(resource: .userPic),
                options: [.forceRefresh]
            )
        } else {
            avatarImage.image = UIImage(resource: .userPic)
        }
    }
    
    private func showLoading(_ isLoading: Bool) {
        if isLoading {
            loader.startAnimating()
            bigStack.isHidden = true
            profileTableView.isHidden = true
        } else {
            loader.stopAnimating()
            bigStack.isHidden = false
            profileTableView.isHidden = false
        }
    }
    
    // MARK: - Actions
    
    @objc private func tapEditButton() {
        presenter.didTapEdit()
        print("переход к экрану редактирования профиля")
    }
    
    @objc private func tapWebSiteLabel() {
        guard let url = webSiteLabel.text else { return }
        presenter.didTapWebSite(url: url)
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileCellName.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileCell.reuseIdentifier,
            for: indexPath
        ) as? ProfileCell else {
            return UITableViewCell()
        }
        
        let item = profileCellName[indexPath.row]
        cell.configure(title: item.type.title, count: "(\(item.count))")
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = profileCellName[indexPath.row]
        
        switch item.type {
        case .myNFT:
            presenter.openMyNFTs()
            print("Переход к экрану Мои NFT")
        case .myFavorites:
            presenter.openFavoritesNFT()
            print("Переход к экрану Избранные NFT")
        }
    }
}

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    
    func updateProfile(_ profile: ProfileResponse) {
        showLoading(false)
        self.profile = profile
        avatarName.text = profile.name
        descriptionLabel.text = profile.description
        webSiteLabel.text = profile.website
        
        showAvatar(profile.avatar)
        
        profileCellName = [
            ProfileItem(type: .myNFT, count: profile.nfts.count),
            ProfileItem(type: .myFavorites, count: profile.likes.count)
        ]
        profileTableView.reloadData()
    }

}

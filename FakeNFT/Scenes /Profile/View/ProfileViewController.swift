//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 21.01.2026.
//

import UIKit
import Kingfisher

// MARK: - Protocols

protocol ProfileViewProtocol: AnyObject, ErrorView {
    func openEditProfile(model: ProfileEditModel)
    func getProfileEditModel() -> ProfileEditModel
    func openMyNFTs()
    func openFavoritesNFTs()
    func openWebView(url: URL)
    func setEditVisible(_ isVisible: Bool)
    func setMenuItems(_ items: [ProfileItem])
    func setWebsiteAsButton(_ isButton: Bool)
    func configureWebsite(isButton: Bool, spacingAfterDescription: CGFloat)
    func setBackButtonVisible(_ isVisible: Bool)
    func display(profile: ProfilUserItem)
}

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {

    // MARK: - Properties

    private let presenter: ProfilePresenterProtocol
    let servicesAssembly: ServicesAssembly

    private var currentProfile: ProfilUserItem?

    private var profileCellName: [ProfileItem] = [
        ProfileItem(type: .myNFT, count: 0),
        ProfileItem(type: .myFavorites, count: 0)
    ]

    // MARK: - UI

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
    
    private lazy var websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(tapWebsiteButton), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        var config = UIButton.Configuration.plain()
        config.title = "Перейти на сайт пользователя"
        config.baseForegroundColor = .blackApp
        config.background.strokeColor = .blackApp
        config.background.strokeWidth = 1
        config.background.cornerRadius = 12
        button.configuration = config
        return button
    }()

    private lazy var bigStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [personStack, descriptionLabel, webSiteLabel, websiteButton])
        stack.axis = .vertical
        stack.alignment = .fill
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

    init(servicesAssembly: ServicesAssembly, presenter: ProfilePresenterProtocol) {
        self.servicesAssembly = servicesAssembly
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
        presenter.viewDidLoad()
        addSubviews()
        setupConstraints()
        navigationItem.title = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.refresh()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = editButton
    }

    private func addSubviews() {
        [bigStack, profileTableView].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        [bigStack, profileTableView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        //bigStack.setCustomSpacing(8, after: descriptionLabel)
        NSLayoutConstraint.activate([
            bigStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            bigStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bigStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
         //   bigStack.heightAnchor.constraint(equalToConstant: 198),

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

    // MARK: - Actions

    @objc private func tapEditButton() {
        presenter.didTapEdit()
        print("переход к экрану редактирования профиля")
    }

    @objc private func tapWebSiteLabel() {
        guard let url = webSiteLabel.text, !url.isEmpty else { return }
        presenter.didTapWebSite(url: url)
    }
    
    @objc private func tapWebsiteButton() {
        guard let url = webSiteLabel.text, !url.isEmpty else { return }
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
            presenter.openFavoritesNFC()
            print("Переход к экрану Избранные NFT")
        }
    }
}

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    
    func display(profile: ProfilUserItem) {
        currentProfile = profile
        avatarName.text = profile.name
        descriptionLabel.text = profile.description ?? ""
        let website = profile.website?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        webSiteLabel.text = website
        let hasWebsite = !website.isEmpty
        webSiteLabel.isUserInteractionEnabled = hasWebsite
        webSiteLabel.textColor = hasWebsite ? .blueUniversal : .greyUniversal
        websiteButton.isEnabled = hasWebsite
        websiteButton.alpha = hasWebsite ? 1 : 0.5
        if var config = websiteButton.configuration {
            config.baseForegroundColor = hasWebsite ? .blackApp : .greyUniversal
            config.background.strokeColor = hasWebsite ? .blackApp : .greyUniversal
            websiteButton.configuration = config
        }
        
        let placeholder = UIImage(resource: .profile)
        avatarImage.tintColor = .greyUniversal
        if let url = profile.avatar {
            avatarImage.kf.setImage(
                with: url,
                placeholder: placeholder,
                options: [.onFailureImage(placeholder)]
            )
        } else {
            avatarImage.image = placeholder
        }
    }
    

    func openEditProfile(model: ProfileEditModel) {
        let presenter = ProfileEditPresenter(model: model)
        let editVC = ProfileEditViewController(presenter: presenter)
        presenter.view = editVC
        navigationController?.pushViewController(editVC, animated: true)
    }

    func getProfileEditModel() -> ProfileEditModel {
        ProfileEditModel(
                name: avatarName.text ?? "",
                description: descriptionLabel.text ?? "",
                site: webSiteLabel.text ?? "",
                avatar: currentProfile?.avatar
            )
    }

    func openMyNFTs() {
        let nftIds = currentProfile?.nfts ?? []
        let likedIds = currentProfile?.likes ?? []
        let updateData = makeProfileUpdateData()
        let presenter = MyNFTsPresenter(
            nftIds: nftIds,
            likedIds: likedIds,
            nftService: servicesAssembly.nftService,
            profileService: servicesAssembly.profileService,
            profileUpdateData: updateData
        )
        let myNFTsVC = MyNFTsViewController(presenter: presenter)
        presenter.view = myNFTsVC
        navigationController?.pushViewController(myNFTsVC, animated: true)
    }

    func openFavoritesNFTs() {
        let nftIds = currentProfile?.likes ?? []
        let updateData = makeProfileUpdateData()
        let presenter = FavoritesNFTPresenter(
            nftIds: nftIds,
            nftService: servicesAssembly.nftService,
            profileService: servicesAssembly.profileService,
            profileUpdateData: updateData
        )
        let myNFTsVC = FavoritesNFTViewController(presenter: presenter)
        presenter.view = myNFTsVC
        navigationController?.pushViewController(myNFTsVC, animated: true)
    }

    private func makeProfileUpdateData() -> ProfileUpdateData {
        ProfileUpdateData(
            name: currentProfile?.name ?? avatarName.text ?? "",
            description: currentProfile?.description ?? descriptionLabel.text ?? "",
            avatar: currentProfile?.avatar?.absoluteString ?? "",
            website: currentProfile?.website ?? webSiteLabel.text ?? ""
        )
    }
    
    func openWebView(url: URL) {
        let presenter = WebViewPresenter()
        let webVC = WebViewProfile(url: url, presenter: presenter)
        presenter.view = webVC
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func setEditVisible(_ isVisible: Bool) {
        navigationItem.rightBarButtonItem = isVisible ? editButton : nil
    }
    
    func setMenuItems(_ items: [ProfileItem]) {
        profileCellName = items
        profileTableView.reloadData()
    }
    
    func setWebsiteAsButton(_ isButton: Bool) {
        webSiteLabel.isHidden = isButton
        websiteButton.isHidden = !isButton
    }
    
    func configureWebsite(isButton: Bool, spacingAfterDescription: CGFloat) {
        webSiteLabel.isHidden = isButton
        websiteButton.isHidden = !isButton
        bigStack.setCustomSpacing(spacingAfterDescription, after: descriptionLabel)
    }
    
    func setBackButtonVisible(_ isVisible: Bool) {
        if isVisible {
            let image = UIImage(resource: .backward).withRenderingMode(.alwaysTemplate)
            let backButton = UIBarButtonItem(
                image: image,
                style: .plain,
                target: self,
                action: #selector(didTapBack)
            )
            backButton.tintColor = UIColor(resource: .blackApp)
            navigationItem.leftBarButtonItem = backButton
            navigationItem.hidesBackButton = true
        } else {
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = true
        }
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

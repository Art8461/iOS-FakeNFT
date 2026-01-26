//
//  ProfileEditViewController.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 22.01.2026.
//

import UIKit

// MARK: - Protocols

protocol ProfileEditViewProtocol: AnyObject {
    func showProfile(model: ProfileEditModel)
    func closeSave() // пока только переход назад к экрану профиля
}

// MARK: - ProfileEditViewController

final class ProfileEditViewController: UIViewController {
    
    // MARK: - Dependencies
    
    private let presenter: ProfileEditPresenterProtocol
    
    // MARK: - UI
    
    private lazy var avatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        
        let image = UIImageView.baseAvatarImage()
        image.image = UIImage(resource: .joaquinPhoenix)
        button.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: button.topAnchor),
            image.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: button.trailingAnchor)
        ])
        
        button.addTarget(self, action: #selector(tapAvatar), for: .touchUpInside)
        return button
    }()
    
    private lazy var editIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(resource: .foto)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    private lazy var nameTextView: UITextView = {
        let textView = UITextView.baseTextView()
        return textView
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView.stackVerticalEditProfile(labels: "Имя", field: nameTextView)
        return stackView
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView.baseTextView()
        return textView
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView.stackVerticalEditProfile(labels: "Описание", field: descriptionTextView)
        return stackView
    }()
    
    private lazy var siteTextView: UITextView = {
        let textView = UITextView.baseTextView()
        return textView
    }()
    
    private lazy var siteStackView: UIStackView = {
        let stackView = UIStackView.stackVerticalEditProfile(labels: "Сайт", field: siteTextView)
        return stackView
    }()
    
    private lazy var bigStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            nameStackView,
            descriptionStackView,
            siteStackView
        ])
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()
    
    // MARK: - Initializers
    
    init(presenter: ProfileEditPresenterProtocol) {
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
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = .backButton(
            target: self,
            action: #selector(tapBackButton)
        )
    }
    
    private func addSubviews() {
        [avatarButton, editIcon, bigStackView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        [avatarButton, editIcon, bigStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            avatarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            editIcon.widthAnchor.constraint(equalToConstant: 22.57),
            editIcon.heightAnchor.constraint(equalToConstant: 22.57),
            editIcon.bottomAnchor.constraint(equalTo: avatarButton.bottomAnchor),
            editIcon.trailingAnchor.constraint(equalTo: avatarButton.trailingAnchor),
            
            bigStackView.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: 24),
            bigStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bigStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func tapBackButton() {
        presenter.didTapBack()
        print("назад к профилю")
    }
    
    @objc private func tapAvatar() {
        print("редактирование аватарки")
    }
}

// MARK: - ProfileEditViewProtocol

extension ProfileEditViewController: ProfileEditViewProtocol {
    
    func closeSave() {
        navigationController?.popViewController(animated: true)
    }
    
    func showProfile(model: ProfileEditModel) {
        nameTextView.text = model.name
        descriptionTextView.text = model.description
        siteTextView.text = model.site
    }
}

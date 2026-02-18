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
    func closeSave()
    func showExitAlert()
    func showAvatarAlert()
    func showPhotoLinkAlert()
    func enableSaveButton(_ enable: Bool)
    func showSaveErrorAlert(retryAction: @escaping () -> Void)
    func setLoading(_ isLoading: Bool)
}

// MARK: - ProfileEditViewController

final class ProfileEditViewController: UIViewController {
    
    // MARK: - Dependencies
    
    private let presenter: ProfileEditPresenter
    private var currentAvatarURL: URL?
    
    // MARK: - UI
    
    private lazy var loader: UIActivityIndicatorView = .baseLoader(in: view)
    
    private lazy var avatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        
        let image = UIImageView.baseAvatarImage()
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
        textView.delegate = self
        return textView
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView.stackVerticalEditProfile(labels: NSLocalizedString("ProfileName" , comment: "edit"), field: nameTextView)
        return stackView
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView.baseTextView()
        textView.delegate = self
        return textView
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView.stackVerticalEditProfile(labels: NSLocalizedString("ProfileDescription" , comment: "edit"), field: descriptionTextView)
        return stackView
    }()
    
    private lazy var siteTextView: UITextView = {
        let textView = UITextView.baseTextView()
        textView.delegate = self
        return textView
    }()
    
    private lazy var siteStackView: UIStackView = {
        let stackView = UIStackView.stackVerticalEditProfile(labels: NSLocalizedString("ProfileWebSite" , comment: "edit"), field: siteTextView)
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
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("ProfileSave" , comment: "edit"), for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.isHidden = true
        button.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    
    init(presenter: ProfileEditPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
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
        setupTextViews()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = .backButton(
            target: self,
            action: #selector(tapBackButton)
        )
    }
    
    private func addSubviews() {
        [avatarButton, editIcon, bigStackView,saveButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        [avatarButton, editIcon, bigStackView, saveButton].forEach {
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
            bigStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.5),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.5),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupTextViews() {
        [nameTextView, descriptionTextView, siteTextView].forEach {
            $0.delegate = self
        }
    }
    
    private func updateAvatar(with link: String) {
        currentAvatarURL = URL(string: link)
        if let imageView = avatarButton.subviews.compactMap({ $0 as? UIImageView }).first {
            imageView.kf.setImage(with: currentAvatarURL, placeholder: UIImage(resource: .userPic))
        }
        saveButton.isHidden = false
    }
    
    private func startLoading() {
        loader.startAnimating()
        view.isUserInteractionEnabled = false
    }

    private func stopLoading() {
        loader.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    @objc private func tapSaveButton() {
        presenter.didTapSave(
            name: nameTextView.text,
            description: descriptionTextView.text,
            site: siteTextView.text,
            avatar: currentAvatarURL?.absoluteString
        )
    }
    
    // MARK: - Actions
    
    @objc private func tapBackButton() {
        presenter.didTapBack()
    }
    
    @objc private func tapAvatar() {
        presenter.didTapAvatar()
    }
    
}

// MARK: - ProfileEditViewProtocol

extension ProfileEditViewController: ProfileEditViewProtocol {
    
    func showExitAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("ProfileGetOut" , comment: "alert"),
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("ProfileStay" , comment: "alert"), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("PrifileExit" , comment: "alert"), style: .default) { [weak self] _ in
            self?.presenter.didTapExit()
        })
        present(alert, animated: true)
    }
    
    func showAvatarAlert() {
        let alert = UIAlertController(title: NSLocalizedString("ProfilePhoto" , comment: "alert"), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ProfileEditPhoto" , comment: "alert"), style: .default) { [weak self] _ in
            self?.presenter.didSelectChangePhoto()
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ProfileDelPhoto" , comment: "alert"), style: .destructive) { [weak self] _ in
            self?.presenter.didSelectDeletePhoto()
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("ProfileCancel" , comment: "alert"), style: .cancel))
        present(alert, animated: true)
    }
    
    func showPhotoLinkAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("ProfileLinkPhoto" , comment: "alert"),
            message: nil,
            preferredStyle: .alert
        )
        alert.addTextField {
            $0.placeholder = NSLocalizedString("ProfileLinkPhoto" , comment: "alert")
            $0.keyboardType = .URL
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("ProfileCancel" , comment: "alert"), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("ProfileSave" , comment: "edit"), style: .default) { [weak self, weak alert] _ in
            guard let link = alert?.textFields?.first?.text, !link.isEmpty else { return }
            self?.updateAvatar(with: link)
        })
        present(alert, animated: true)
    }
    
    func enableSaveButton(_ enable: Bool) {
        saveButton.isHidden = !enable
    }
    
    func closeSave() {
        navigationController?.popViewController(animated: true)
    }
    
    func showProfile(model: ProfileEditModel) {
        nameTextView.text = model.name
        descriptionTextView.text = model.description
        siteTextView.text = model.site
        
        if let imageView = avatarButton.subviews.compactMap({ $0 as? UIImageView }).first {
            imageView.image = UIImage(resource: .userPic)
            if let avatar = model.avatar,
               !avatar.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
               let url = URL(string: avatar) {
                imageView.kf.setImage(with: url, placeholder: UIImage(resource: .userPic))
                currentAvatarURL = url
            } else {
                currentAvatarURL = nil
            }
        }
        saveButton.isHidden = true
    }
    
    func showSaveErrorAlert(retryAction: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.presentErrorRetry(retryAction)
        }
    }
    
    func setLoading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            isLoading ? self.startLoading() : self.stopLoading()
        }
    }
}

extension ProfileEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter.didChangeText()
    }
}

//
//  ProfileEditViewController.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 22.01.2026.
//
import UIKit

protocol ProfileEditViewProtocol: AnyObject {
    func showProfile(model: ProfileEditModel)
    func closeSave() //пока только переход назад к экрану профиля, позже передачу отредактированных данных
}

final class ProfileEditViewController: UIViewController {
    
    private let presenter: ProfileEditPresenterProtocol
    
    init(presenter: ProfileEditPresenterProtocol) {
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
        presenter.viewDidLoad()
    }
    
    private lazy var backButton: UIBarButtonItem = {
        let image = UIImage(resource: .chevronBackward)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(tapBackButton))
        button.tintColor = .blackApp
        return button
    }()
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView.baseAvatarImage()
        image.image = UIImage(resource: .joaquinPhoenix) 
        return image
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
        let stack = UIStackView(arrangedSubviews: [nameStackView, descriptionStackView, siteStackView])
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()
    
    private func setupNavigationBar(){
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func addSubviews() {
        [avatarImage,bigStackView].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        [avatarImage, bigStackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            avatarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            bigStackView.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 24),
            bigStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bigStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc func tapBackButton(){
        presenter.didTapBack()
    }
}

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


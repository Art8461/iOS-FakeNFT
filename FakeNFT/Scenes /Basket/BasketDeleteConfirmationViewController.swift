//
//  BasketDeleteConfirmationViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 22.01.2026.
//

import UIKit
import Kingfisher

final class BasketDeleteConfirmationViewController: UIViewController {
    var onDelete: (() -> Void)?
    var onCancel: (() -> Void)?
    var imageURL: URL?
    
    private let blurEffect = UIBlurEffect(style: .systemMaterialDark)
    private lazy var blurView = UIVisualEffectView(effect: blurEffect)
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let deleteButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setupBlur()
        setupContent()
    }
    
    private func setupBlur() {
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCancel))
        blurView.addGestureRecognizer(tap)
    }
    
    private func setupContent() {
        
        if let url = imageURL {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = nil
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        titleLabel.text = NSLocalizedString("Вы уверены, что хотите \nудалить объект из корзины?", comment: "Confirmation title")
        titleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor(resource: .blackApp)
        
        deleteButton.setTitle(NSLocalizedString("Удалить", comment: "delete button"), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Вернуться", comment: "cancel button"), for: .normal)
        
        deleteButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        
        deleteButton.backgroundColor = UIColor(resource: .blackApp)
        deleteButton.setTitleColor(UIColor(resource: .redUniversal), for: .normal)
        deleteButton.layer.cornerRadius = 12
        deleteButton.clipsToBounds = true
        
        cancelButton.backgroundColor = UIColor(resource: .blackApp)
        cancelButton.setTitleColor(UIColor(resource: .whiteApp), for: .normal)
        cancelButton.layer.cornerRadius = 12
        cancelButton.clipsToBounds = true
        
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        
        let buttonsRow = UIStackView(arrangedSubviews: [deleteButton, cancelButton])
        buttonsRow.axis = .horizontal
        buttonsRow.spacing = 8
        buttonsRow.alignment = .center
        buttonsRow.distribution = .fill
        
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, buttonsRow])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        
        blurView.contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: blurView.contentView.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: blurView.contentView.trailingAnchor, constant: -24)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 108),
            imageView.heightAnchor.constraint(equalToConstant: 108)
        ])
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.widthAnchor.constraint(equalToConstant: 127),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func didTapDelete() {
        dismiss(animated: true) { [weak self] in
            self?.onDelete?()
        }
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true) { [weak self] in
            self?.onCancel?()
        }
    }
}

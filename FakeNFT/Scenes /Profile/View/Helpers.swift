//
//  Extension.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 22.01.2026.
//
import UIKit

extension UIImageView {
    
    static func baseAvatarImage() -> UIImageView {
        let image = UIImageView()
        image.layer.cornerRadius = 35
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 70),
            image.heightAnchor.constraint(equalToConstant: 70)
        ])
        return image
    }
    
}

extension UITextView {
    
    static func baseTextView() -> UITextView {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.backgroundColor = .lightGreyApp
        textView.layer.cornerRadius = 12
        textView.tintColor = .blackApp
        textView.isScrollEnabled = false
        textView.clipsToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        return textView
    }
}

extension UILabel {
    
    static func baseLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .blackApp
        return label
    }
}

extension UIStackView {
    
    static func stackVerticalEditProfile(labels: String, field: UIView) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = labels
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .blackApp
        let stack = UIStackView(arrangedSubviews: [titleLabel, field])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }
}

//
//  CurrencyCell.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 24.01.2026.
//

import UIKit

final class CurrencyCell: UICollectionViewListCell, ReuseIdentifying {

    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let codeLabel = UILabel()
    private let textStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(name: String, code: String, image: UIImage?) {
        nameLabel.text = name
        codeLabel.text = code
        iconImageView.image = image
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        nameLabel.text = nil
        codeLabel.text = nil
    }

    private func setupViews() {
        
        containerView.backgroundColor = UIColor(resource: .lightGreyApp)
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        
        iconImageView.contentMode = .scaleAspectFit

        nameLabel.font = .bodyBold
        nameLabel.textColor = UIColor(resource: .blackApp)
        nameLabel.numberOfLines = 1

        codeLabel.font = .caption2
        codeLabel.textColor = UIColor(resource: .greenUniversal)
        codeLabel.numberOfLines = 1

        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.addArrangedSubview(nameLabel)
        textStack.addArrangedSubview(codeLabel)

        contentView.addSubview(containerView)
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(textStack)
    }

    private func setupLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 168),
            containerView.heightAnchor.constraint(equalToConstant: 46),

            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            iconImageView.heightAnchor.constraint(equalToConstant: 36),

            textStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            textStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -12)
        ])
    }
}

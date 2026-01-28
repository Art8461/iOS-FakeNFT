//
//  CurrencyCell.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 24.01.2026.
//

import UIKit
import Kingfisher

final class CurrencyCell: UICollectionViewListCell, ReuseIdentifying {

    private let containerView = UIView()
    private let containerIconImage = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let nameLabel = UILabel()
    private let textStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: CurrencyCellModel) {
        titleLabel.text = model.title
        nameLabel.text = model.name
        iconImageView.kf.setImage(with: model.image)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
        nameLabel.text = nil
    }

    private func setupViews() {
        
        backgroundConfiguration = .clear()
        containerView.backgroundColor = UIColor(resource: .lightGreyApp)
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        titleLabel.textColor = UIColor(resource: .blackApp)
        titleLabel.numberOfLines = 1

        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        nameLabel.textColor = UIColor(resource: .greenUniversal)
        nameLabel.numberOfLines = 1

        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(nameLabel)

        containerIconImage.backgroundColor = UIColor(resource: .blackUniversal)
        containerIconImage.layer.cornerRadius = 6
        containerIconImage.layer.masksToBounds = true
        containerIconImage.addSubview(iconImageView)

        contentView.addSubview(containerView)

        containerView.addSubview(containerIconImage)
        containerView.addSubview(textStack)
    }

    private func setupLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerIconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 168),
            containerView.heightAnchor.constraint(equalToConstant: 46),

            containerIconImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            containerIconImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            containerIconImage.widthAnchor.constraint(equalToConstant: 36),
            containerIconImage.heightAnchor.constraint(equalToConstant: 36),
            
            iconImageView.topAnchor.constraint(equalTo: containerIconImage.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: containerIconImage.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: containerIconImage.trailingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: containerIconImage.bottomAnchor),

            textStack.leadingAnchor.constraint(equalTo: containerIconImage.trailingAnchor, constant: 12),
            textStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -12)
        ])
    }
    
    override var isSelected: Bool {
        didSet { updateSelectionState() }
    }

    override var isHighlighted: Bool {
        didSet { updateSelectionState() }
    }

    private func updateSelectionState() {
        let isActive = isSelected || isHighlighted
        containerView.layer.borderWidth = isActive ? 1 : 0
        containerView.layer.borderColor = UIColor(resource: .blackApp).cgColor
        containerView.backgroundColor = UIColor(resource: .lightGreyApp)
    }
}

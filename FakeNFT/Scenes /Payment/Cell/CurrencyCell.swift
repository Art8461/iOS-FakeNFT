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
        
        containerView.backgroundColor = UIColor(resource: .lightGreyApp)
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        
        iconImageView.contentMode = .scaleAspectFit

        titleLabel.font = .bodyBold
        titleLabel.textColor = UIColor(resource: .blackApp)
        titleLabel.numberOfLines = 1

        nameLabel.font = .caption2
        nameLabel.textColor = UIColor(resource: .greenUniversal)
        nameLabel.numberOfLines = 1

        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(nameLabel)

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

//
//  BasketItemCell.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 21.01.2026.
//

import UIKit
import Kingfisher

struct BasketItemCellModel {
    let id: String
    let title: String
    let priceText: String
    let rating: Int   // 0...5
    let imageURL: URL?
}

final class BasketItemCell: UICollectionViewListCell, ReuseIdentifying {
    
    private let containerView = UIView()
    private let previewImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingView = StarRatingView()
    private let priceTitleLabel = UILabel()
    private let priceValueLabel = UILabel()
    private let deleteButton = UIButton(type: .system)
    
    private let textStack = UIStackView()
    private let titleRatingStack = UIStackView()
    private let priceStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with model: BasketItemCellModel) {
        titleLabel.text = model.title
        priceValueLabel.text = model.priceText
        ratingView.setRating(model.rating)
        previewImageView.kf.setImage(with: model.imageURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImageView.image = nil
        ratingView.setRating(0)
        titleLabel.text = nil
        priceValueLabel.text = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attrs = super.preferredLayoutAttributesFitting(layoutAttributes)
        attrs.size.height = 140
        return attrs
    }
    
    private func setupViews() {
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        previewImageView.layer.cornerRadius = 12
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = UIColor(resource: .blackApp)
        titleLabel.numberOfLines = 1
        
        priceTitleLabel.text = NSLocalizedString("Цена", comment: "price title")
        priceTitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        priceTitleLabel.textColor = UIColor(resource: .blackApp)
        
        priceValueLabel.font = .systemFont(ofSize: 17, weight: .bold)
        priceValueLabel.textColor = UIColor(resource: .blackApp)
        
        priceStack.axis = .vertical
        priceStack.spacing = 2
        priceStack.addArrangedSubview(priceTitleLabel)
        priceStack.addArrangedSubview(priceValueLabel)
        
        titleRatingStack.axis = .vertical
        titleRatingStack.spacing = 4
        titleRatingStack.addArrangedSubview(titleLabel)
        titleRatingStack.addArrangedSubview(ratingView)

        textStack.axis = .vertical
        textStack.spacing = 12
        textStack.addArrangedSubview(titleRatingStack)
        textStack.addArrangedSubview(priceStack)
        
        deleteButton.setImage(UIImage(resource: .basketDel), for: .normal)
        deleteButton.tintColor = UIColor(resource: .blackApp)
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(previewImageView)
        containerView.addSubview(textStack)
        containerView.addSubview(deleteButton)
    }
    
    private func setupLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        textStack.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            previewImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            previewImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            previewImageView.widthAnchor.constraint(equalToConstant: 108),
            previewImageView.heightAnchor.constraint(equalToConstant: 108),
            
            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            
            textStack.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: 20),
            textStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
    }
}

final class StarRatingView: UIView {
    private let stack = UIStackView()
    private var stars: [UIImageView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        for _ in 0..<5 {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            stars.append(iv)
            stack.addArrangedSubview(iv)
        }
        setRating(0)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setRating(_ rating: Int) {
        let clamped = min(max(rating, 0), 5)
        for (index, iv) in stars.enumerated() {
            iv.image = UIImage(resource: .star)
            iv.tintColor = index < clamped ? .systemYellow : .lightGray
        }
    }
}

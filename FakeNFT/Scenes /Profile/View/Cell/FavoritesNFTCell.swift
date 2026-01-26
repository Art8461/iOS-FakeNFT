//
//  FavoritesNFTCell.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 24.01.2026.
//

import UIKit

final class FavoritesNFTCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FavoritesNFTCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageNFTView: UIImageView = {
        let imageNFTView = UIImageView()
        imageNFTView.contentMode = .scaleAspectFill
        imageNFTView.clipsToBounds = true
        imageNFTView.layer.cornerRadius = 12
        return imageNFTView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .clear
        return button
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return titleLabel
    }()
    
    private let starsImageView: UIImageView = {
        let starsImageView = UIImageView()
        starsImageView.contentMode = .scaleAspectFit
        return starsImageView
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, starsImageView, priceValueLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.setCustomSpacing(8, after: starsImageView)
        return stack
    }()

    
    private func addSubviews() {
        
        [imageNFTView, likeButton, infoStack].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        [imageNFTView, likeButton, infoStack].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            
            imageNFTView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageNFTView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageNFTView.widthAnchor.constraint(equalToConstant: 80),
            imageNFTView.heightAnchor.constraint(equalToConstant: 80),
            
            likeButton.topAnchor.constraint(equalTo: imageNFTView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageNFTView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            
            infoStack.leadingAnchor.constraint(equalTo: imageNFTView.trailingAnchor, constant: 20),
            infoStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with model: NFTCartModel) {
        imageNFTView.image = UIImage(named: model.imageName)
        likeButton.setImage(UIImage(named: model.likeImageName), for: .normal)
        titleLabel.text = model.title
        starsImageView.image = UIImage(named: model.starsImageName)
        priceValueLabel.text = model.price
    }


    
}



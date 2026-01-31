//
//  FavoritesNFTCell.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 24.01.2026.
//

import UIKit
import Kingfisher

final class FavoritesNFTCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "FavoritesNFTCell"
    
    // MARK: - UI Elements
    
    private let imageNFTView: UIImageView = .baseNFTImage()
    private let likeButton: UIButton = .likeButton(color: .redUniversal)
    private let titleLabel: UILabel = .baseLabel(font: .systemFont(ofSize: 17, weight: .bold))
    private let ratingView = StarRatingView()
    private let priceValueLabel: UILabel = .baseLabel(font: .systemFont(ofSize: 15, weight: .regular))
    var onLikeTap: (() -> Void)?
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView.stackVertical(spacing: 4, views: [titleLabel, ratingView, priceValueLabel])
        stack.alignment = .leading
        stack.setCustomSpacing(8, after: ratingView)
        return stack
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .whiteApp
        addSubviews()
        setupConstraints()
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
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
    
    // MARK: - Configure
    
    func configure(with model: NFTCartModel) {
        if let url = model.imageURL {
            imageNFTView.kf.setImage(
                with: url,
                placeholder: UIImage(resource: .placeholderpayment)
            )
        } else {
            imageNFTView.image = UIImage(named: model.imageName)
        }
        let likeImage = UIImage(named: "Favourites")?.withRenderingMode(.alwaysTemplate)
        likeButton.setImage(likeImage, for: .normal)
        likeButton.tintColor = model.isLiked ? .redUniversal : .greyUniversal
        titleLabel.text = model.title
        ratingView.setRating(model.rating)
        priceValueLabel.text = String(format: "%.2f ETH", model.price)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageNFTView.kf.cancelDownloadTask()
        imageNFTView.image = nil
        likeButton.setImage(nil, for: .normal)
        likeButton.tintColor = .greyUniversal
        titleLabel.text = nil
        ratingView.setRating(0)
        priceValueLabel.text = nil
        onLikeTap = nil
    }

    @objc private func didTapLike() {
        onLikeTap?()
    }
}

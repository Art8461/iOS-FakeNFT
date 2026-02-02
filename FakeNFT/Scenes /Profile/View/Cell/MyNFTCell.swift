//
//  MyNFTCell.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 23.01.2026.
//

import UIKit
import Kingfisher

final class MyNFTCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "MyNFTCell"
    
    // MARK: - UI Elements
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteApp
        view.layer.masksToBounds = true
        return view
    }()
    
    private let imageNFTView: UIImageView = .baseNFTImage()
    private let likeButton: UIButton = .likeButton(color: .whiteUniversal)
    private let titleLabel: UILabel = {
        let label = UILabel.baseLabel(font: .systemFont(ofSize: 17, weight: .bold))
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private let ratingView = StarRatingView()
    private let authorPrefixLabel: UILabel = .baseLabel(text: "от", font: .systemFont(ofSize: 15, weight: .regular))
    private let nameAuthorLabel: UILabel = .baseLabel(font: .systemFont(ofSize: 13, weight: .regular))
    private let priceTitleLabel: UILabel = .baseLabel(text: "Цена", font: .systemFont(ofSize: 13, weight: .regular))
    private let priceValueLabel: UILabel = .baseLabel(font: .systemFont(ofSize: 17, weight: .bold))
    var onLikeTap: (() -> Void)?
    
    private lazy var authorStack: UIStackView = {
        let stack = UIStackView.stackHorizontal(spacing: 4, views: [authorPrefixLabel, nameAuthorLabel])
        stack.alignment = .firstBaseline
        return stack
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView.stackVertical(spacing: 4, views: [titleLabel, ratingView, authorStack])
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var priceStack: UIStackView = {
        let stack = UIStackView.stackVertical(spacing: 4, views: [priceTitleLabel, priceValueLabel])
        stack.alignment = .leading
        return stack
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .whiteApp
        addSubviews()
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceStack.setContentCompressionResistancePriority(.required, for: .horizontal)
        setupConstraints()
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        [imageNFTView, likeButton, infoStack, priceStack].forEach { containerView.addSubview($0) }
    }
    
    private func setupConstraints() {
        [imageNFTView, likeButton, infoStack, priceStack, containerView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39),
            
            imageNFTView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageNFTView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageNFTView.widthAnchor.constraint(equalToConstant: 108),
            imageNFTView.heightAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: imageNFTView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageNFTView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            
            infoStack.leadingAnchor.constraint(equalTo: imageNFTView.trailingAnchor, constant: 20),
            infoStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            infoStack.trailingAnchor.constraint(lessThanOrEqualTo: priceStack.leadingAnchor),
            
            priceStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            priceStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
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
        likeButton.tintColor = model.isLiked ? .redUniversal : .whiteUniversal
        titleLabel.text = model.title
        ratingView.setRating(model.rating)
        let authorName = model.authorName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        nameAuthorLabel.text = authorName
        authorStack.isHidden = authorName.isEmpty
        priceValueLabel.text = String(format: "%.2f ETH", model.price)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageNFTView.kf.cancelDownloadTask()
        imageNFTView.image = nil
        likeButton.setImage(nil, for: .normal)
        likeButton.tintColor = .whiteUniversal
        titleLabel.text = nil
        ratingView.setRating(0)
        nameAuthorLabel.text = nil
        authorStack.isHidden = false
        priceValueLabel.text = nil
        onLikeTap = nil
    }

    @objc private func didTapLike() {
        onLikeTap?()
    }
}

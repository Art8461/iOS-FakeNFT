//
//  MyNFTCell.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 23.01.2026.
//

import UIKit

final class MyNFTCell: UITableViewCell {
    
    static let reuseIdentifier = "MyNFTCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteApp
        view.layer.masksToBounds = true
        return view
    }()
    
    //картинка NFT + лайк
    private let imageNFTView: UIImageView = {
        let imageNFTView = UIImageView()
        imageNFTView.contentMode = .scaleAspectFill
        imageNFTView.clipsToBounds = true
        imageNFTView.layer.cornerRadius = 12
        return imageNFTView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .blackApp
        return button
    }()
    
    //ИнфоСтек Имя + рейтинг + автор(от+имя)
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
    
    private let authorPrefixLabel: UILabel = {
        let label = UILabel()
        label.text = "от"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .blackApp
        return label
    }()
    
    private let nameAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .blackApp
        return label
    }()
    
    //цена + ценник
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    //стеки
    private lazy var authorStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            authorPrefixLabel,
            nameAuthorLabel
        ])
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,starsImageView, authorStack ])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var priceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceTitleLabel,priceValueLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .trailing
        return stack
    }()
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        [imageNFTView, likeButton, infoStack, priceStack].forEach { containerView.addSubview($0) }
    }
    
    private func setupConstraints() {
        [imageNFTView, likeButton, infoStack, priceStack,containerView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39),
            
            imageNFTView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageNFTView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageNFTView.widthAnchor.constraint(equalToConstant: 108),
            imageNFTView.heightAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: imageNFTView.topAnchor, constant: 12),
            likeButton.trailingAnchor.constraint(equalTo: imageNFTView.trailingAnchor, constant: 12),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            
            infoStack.leadingAnchor.constraint(equalTo: imageNFTView.trailingAnchor, constant: 20),
            infoStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            priceStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            priceStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func configure(with model: NFTCartModel) {
        imageNFTView.image = UIImage(named: model.imageName)
        likeButton.setImage(UIImage(named: model.likeImageName), for: .normal)
        titleLabel.text = model.title
        starsImageView.image = UIImage(named: model.starsImageName)
        nameAuthorLabel.text = model.authorName
        priceValueLabel.text = model.price
    }


    
}

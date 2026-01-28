//
//  StatsItemCell.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 28.01.2026.
//

import UIKit
import Kingfisher

final class StatsItemCell: UICollectionViewListCell, ReuseIdentifying {
    
    private let containerView = UIView() //общий
    private let containerProfileView = UIView() //общий 
    private let previewAvatarImgView = UIImageView()
    private let nameLabel = UILabel()
    private let countNftLabel = UILabel()
    private let countRaitLanel = UILabel()
    
    private let textStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with model: StatsItemCellModel) {
        previewAvatarImgView.tintColor = .greyUniversal
        previewAvatarImgView.kf.setImage(
            with: model.avatar,
            placeholder: UIImage(resource: .profile)
        )
        nameLabel.text = String(model.name)
        countNftLabel.text = String(model.nfts.count)
        countRaitLanel.text = String(model.rating)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewAvatarImgView.image = nil
        nameLabel.text = nil
        countNftLabel.text = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attrs = super.preferredLayoutAttributesFitting(layoutAttributes)
        attrs.size.height = 80
        return attrs
    }
    
    private func setupViews() {
        backgroundConfiguration = .clear()
        
        countRaitLanel.font = .systemFont(ofSize: 15, weight: .regular)
        countRaitLanel.textColor = .blackApp
        countRaitLanel.textAlignment = .center
        
        containerProfileView.backgroundColor = UIColor(resource: .lightGreyApp)
        containerProfileView.layer.cornerRadius = 12
        containerProfileView.layer.masksToBounds = true
        
        previewAvatarImgView.contentMode = .scaleAspectFill
        previewAvatarImgView.clipsToBounds = true
        previewAvatarImgView.layer.cornerRadius = 14
        
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.textColor = .blackApp
        nameLabel.numberOfLines = 0
        
        countNftLabel.font = .systemFont(ofSize: 22, weight: .bold)
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(countRaitLanel)
        containerView.addSubview(containerProfileView)
        
        containerProfileView.addSubview(previewAvatarImgView)
        containerProfileView.addSubview(nameLabel)
        containerProfileView.addSubview(countNftLabel)
    }
    
    private func setupLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        previewAvatarImgView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        countNftLabel.translatesAutoresizingMaskIntoConstraints = false
        countRaitLanel.translatesAutoresizingMaskIntoConstraints = false
        containerProfileView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            countRaitLanel.widthAnchor.constraint(equalToConstant: 27),
            countRaitLanel.heightAnchor.constraint(equalToConstant: 20),
            countRaitLanel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            countRaitLanel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            containerProfileView.topAnchor.constraint(equalTo: containerView.topAnchor),
            containerProfileView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            containerProfileView.leadingAnchor.constraint(equalTo: countRaitLanel.trailingAnchor, constant: 8),
            containerProfileView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            containerProfileView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            
            previewAvatarImgView.leadingAnchor.constraint(equalTo: containerProfileView.leadingAnchor, constant: 16),
            previewAvatarImgView.centerYAnchor.constraint(equalTo: containerProfileView.centerYAnchor),
            previewAvatarImgView.heightAnchor.constraint(equalToConstant: 28),
            previewAvatarImgView.widthAnchor.constraint(equalToConstant: 28),
            
            nameLabel.centerYAnchor.constraint(equalTo: containerProfileView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: previewAvatarImgView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: countNftLabel.leadingAnchor, constant: -8),
            
            countNftLabel.trailingAnchor.constraint(equalTo: containerProfileView.trailingAnchor, constant: -16),
            countNftLabel.centerYAnchor.constraint(equalTo: containerProfileView.centerYAnchor)
        ])
    }
}

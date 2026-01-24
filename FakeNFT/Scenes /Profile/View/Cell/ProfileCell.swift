//
//  ProfileCell.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 21.01.2026.
//
import UIKit

final class ProfileCell: UITableViewCell {
    
    static let reuseIdentifier = "ProfileCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .blackApp
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .blackApp
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = 8
        return stack
    }()
    
    private let chevronImage: UIImageView = {
        let imageLabel = UIImageView()
        imageLabel.image = UIImage(resource: .forward)
        imageLabel.contentMode = .scaleAspectFit
        imageLabel.tintColor = .blackApp
        return imageLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(countLabel)
        [stackView, chevronImage].forEach({ contentView.addSubview($0) })
    }
    
    private func setupConstraints() {
        [stackView, chevronImage].forEach{$0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevronImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(title:String, count:String){
        titleLabel.text = title
        countLabel.text = count
    }
    
}

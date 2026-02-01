//
//  StarRatingNFTView.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 01.02.2026.
//

import UIKit

final class StarRatingNFTView: UIView {
    private let stack = UIStackView()
    private var stars: [UIImageView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        stack.setContentHuggingPriority(.required, for: .horizontal)
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
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

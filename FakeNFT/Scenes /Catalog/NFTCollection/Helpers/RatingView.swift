import UIKit

final class SimpleRatingView: UIView {
    private var stars: [UIImageView] = []
    private let starSize: CGFloat
    private let spacing: CGFloat

    init(starSize: CGFloat = 12, spacing: CGFloat = 2) {
        self.starSize = starSize
        self.spacing = spacing
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupStars()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStars() {
        // Цвет и конфигурация символов
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: starSize, weight: .regular)
        for i in 0..<5 {
            let iv = UIImageView()
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.contentMode = .scaleAspectFit
            iv.tintColor = .yellow
            iv.preferredSymbolConfiguration = symbolConfig
            // по умолчанию пустая звезда
            iv.image = UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate)
            addSubview(iv)
            stars.append(iv)

            // размер каждой звезды
            NSLayoutConstraint.activate([
                iv.widthAnchor.constraint(equalToConstant: starSize),
                iv.heightAnchor.constraint(equalToConstant: starSize),
                iv.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])

            // leading: первый — к leading, остальные — к trailing предыдущей + spacing
            if i == 0 {
                iv.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            } else {
                iv.leadingAnchor.constraint(equalTo: stars[i - 1].trailingAnchor, constant: spacing).isActive = true
            }
        }

        // trailing <= last star trailing (чтобы view имело понятную ширину)
        if let last = stars.last {
            last.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }

    func setRating(_ rating: Int) {
        // clamp rating to 0...5
        let r = max(0, min(5, rating))
        for (i, iv) in stars.enumerated() {
            let sysName = i < r ? "star.fill" : "star"
            iv.image = UIImage(systemName: sysName)?.withRenderingMode(.alwaysTemplate)
        }
    }

    // при желании можно переопределить intrinsicContentSize:
    override var intrinsicContentSize: CGSize {
        let width = CGFloat(stars.count) * starSize + CGFloat(max(0, stars.count - 1)) * spacing
        return CGSize(width: width, height: starSize)
    }
}



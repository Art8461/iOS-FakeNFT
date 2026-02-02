import UIKit

protocol NFTCollectionCellDelegate: AnyObject {
  func nftCellDidTapFavorite(_ cell: NFTCollectionCell)
  func nftCellDidTapCart(_ cell: NFTCollectionCell)
}

final class NFTCollectionCell: UICollectionViewCell {
  // MARK: - Subviews
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let authorLabel = UILabel()
  private let priceLabel = UILabel()
  private let favoriteButton = UIButton(type: .system)
  private let cartButton = UIButton(type: .system)

  // MARK: - Properties
  weak var delegate: NFTCollectionCellDelegate?

  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupLayout()
    setupActions()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public
  struct ViewModel {
    let title: String
    let author: String
    let priceText: String
    let isFavorite: Bool
    let inCart: Bool
    let image: UIImage? 
  }

  func configure(with viewModel: ViewModel) {
    titleLabel.text = viewModel.title
    authorLabel.text = viewModel.author
    priceLabel.text = viewModel.priceText
    imageView.image = viewModel.image

    let favoriteImageName = viewModel.isFavorite ? "heart.fill" : "heart"
    favoriteButton.setImage(UIImage(systemName: favoriteImageName), for: .normal)

    let cartImageName = viewModel.inCart ? "cart.fill" : "cart"
    cartButton.setImage(UIImage(systemName: cartImageName), for: .normal)
  }

  // MARK: - Setup
  private func setupViews() {
    contentView.backgroundColor = .secondarySystemBackground
    contentView.layer.cornerRadius = 12
    contentView.clipsToBounds = true

    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true

    titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
    titleLabel.numberOfLines = 2

    authorLabel.font = .systemFont(ofSize: 12, weight: .regular)
    authorLabel.textColor = .secondaryLabel

    priceLabel.font = .systemFont(ofSize: 13, weight: .medium)

    favoriteButton.tintColor = .systemRed
    cartButton.tintColor = .systemBlue

    [imageView, titleLabel, authorLabel, priceLabel, favoriteButton, cartButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 120),

      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

      authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
      authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

      priceLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
      priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

      favoriteButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
      favoriteButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

      cartButton.centerYAnchor.constraint(equalTo: favoriteButton.centerYAnchor),
      cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
    ])
  }

  private func setupActions() {
    favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    cartButton.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
  }

  // MARK: - Actions
  @objc private func favoriteTapped() {
    delegate?.nftCellDidTapFavorite(self)
  }

  @objc private func cartTapped() {
    delegate?.nftCellDidTapCart(self)
  }
}


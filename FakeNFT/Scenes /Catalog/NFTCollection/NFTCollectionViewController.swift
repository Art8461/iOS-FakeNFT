import UIKit

final class NFTCollectionViewController: UIViewController {
    private enum CollectionLayout {
        static let backButtonTop: CGFloat = 11
        static let backButtonLeading: CGFloat = 9
        static let backButtonSize: CGFloat = 24
        
        static let coverImageHeight: CGFloat = 310
        
        static let titleTop: CGFloat = 16
        static let titleLeading: CGFloat = 16
        static let titeTrailing: CGFloat = -16
        
        static let authorTop: CGFloat = 8
        static let authorSpacing: CGFloat = 4
        
        static let descriptionTop: CGFloat = 4
        
        static let collectionTop: CGFloat = 24
        static let collectionLeading: CGFloat = 16
        static let collectionTrailing: CGFloat = -16
        static let collectionBottom: CGFloat = -16
        static let collectionBottomInset: CGFloat = 16
        
        static let itemWidth: CGFloat = 108
        static let itemHeight: CGFloat = 192
    }
    
    // MARK: - UI
    private let backButton = UIButton(type: .system)
    private let coverImageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let collectionView: UICollectionView
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let collection: Catalog
    
    
    
    // MARK: - MVP
    var output: NFTCollectionViewOutput?
    
    // MARK: - Data
    private var nfts: [Nft] = []
    private var favorites: Set<String> = []
    private var itemsInCart: Set<String> = []
    
    // MARK: - Init
    init(collection: Catalog) {
        self.collection = collection
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: CollectionLayout.itemWidth, height: CollectionLayout.itemHeight)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: CollectionLayout.collectionBottomInset,
            right: 0
        )
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        setupViews()
        setupLayout()
        setupCollection()
        applyCollectionHeader()
        
        output?.viewDidLoad()
    }
    
    private func applyCollectionHeader() {
        titleLabel.text = collection.name
        authorLabel.text = collection.author
        descriptionLabel.text = collection.description
        coverImageView.image = UIImage(named: collection.cover)
    }
    
    // MARK: - Setup
    private func setupViews() {
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .label
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        authorLabel.font = .systemFont(ofSize: 14, weight: .medium)
        authorLabel.textColor = .secondaryLabel
        
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        
        activityIndicator.hidesWhenStopped = true
        
        [backButton, coverImageView, titleLabel, authorLabel, descriptionLabel, collectionView, activityIndicator]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
            }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CollectionLayout.backButtonTop),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CollectionLayout.backButtonLeading),
            backButton.widthAnchor.constraint(equalToConstant: CollectionLayout.backButtonSize),
            backButton.heightAnchor.constraint(equalToConstant: CollectionLayout.backButtonSize),
            
            coverImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: CollectionLayout.coverImageHeight),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: CollectionLayout.titleTop),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CollectionLayout.titleLeading),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CollectionLayout.titeTrailing),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: CollectionLayout.authorTop),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: CollectionLayout.descriptionTop),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: CollectionLayout.collectionTop),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CollectionLayout.collectionLeading),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CollectionLayout.collectionTrailing),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CollectionLayout.collectionBottom),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCollection() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NFTCollectionCell.self, forCellWithReuseIdentifier: "NFTCollectionCell")
    }
    
    // MARK: - Actions
    @objc private func backTapped() {
        output?.didTapBack()
    }
}

// MARK: - UICollectionViewDataSource
extension NFTCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nfts.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "NFTCollectionCell",
            for: indexPath
        ) as? NFTCollectionCell else {
            return UICollectionViewCell()
        }
        
        let nft = nfts[indexPath.item]
        let isFavorite = favorites.contains(nft.id)
        let inCart = itemsInCart.contains(nft.id)
        
        let viewModel = NFTCollectionCell.ViewModel(
            title: nft.name,
            author: nft.author,
            priceText:  String(nft.price),
            isFavorite: isFavorite,
            inCart: inCart,
            image: Self.makeImage(from: nft.images.first)
        )
        
        cell.configure(with: viewModel)
        cell.delegate = self
        return cell
    }
}

private extension NFTCollectionViewController {
    static func makeImage(from url: URL?) -> UIImage? {
        guard let url else { return nil }
        
        // Моки: asset://Catalog
        if url.scheme == "asset" {
            let assetName = url.host ?? url.path.replacingOccurrences(of: "/", with: "")
            return UIImage(named: assetName)
        }
        
        return nil
    }
}

// MARK: - UICollectionViewDelegate
extension NFTCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nft = nfts[indexPath.item]
        output?.didSelectNft(with: nft.id)
    }
}

// MARK: - NFTCollectionCellDelegate
extension NFTCollectionViewController: NFTCollectionCellDelegate {
    func nftCellDidTapFavorite(_ cell: NFTCollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let nft = nfts[indexPath.item]
        output?.didToggleFavorite(for: nft.id)
    }
    
    func nftCellDidTapCart(_ cell: NFTCollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let nft = nfts[indexPath.item]
        output?.didToggleCart(for: nft.id)
    }
}

// MARK: - NFTCollectionViewInput
extension NFTCollectionViewController: NFTCollectionViewInput {
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateNfts(_ nfts: [Nft]) {
        self.nfts = nfts
        collectionView.reloadData()
    }
    
    func updateFavorites(_ favorites: [String]) {
        self.favorites = Set(favorites)
        collectionView.reloadData()
    }
    
    func updateCart(_ itemsInCart: [String]) {
        self.itemsInCart = Set(itemsInCart)
        collectionView.reloadData()
    }
}




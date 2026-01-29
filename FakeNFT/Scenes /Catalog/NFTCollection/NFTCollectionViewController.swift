import UIKit

final class NFTCollectionViewController: UIViewController {
    
    // MARK: - Layout Constants
    private enum CollectionLayout {
        static let coverImageHeight: CGFloat = 310
        
        static let titleTop: CGFloat = 16
        static let titleLeading: CGFloat = 16
        static let titleTrailing: CGFloat = -16
        
        static let authorTop: CGFloat = 8
        static let authorSpacing: CGFloat = 4
        
        static let descriptionTop: CGFloat = 4
        
        static let collectionTop: CGFloat = 24
        static let collectionLeading: CGFloat = 16
        static let collectionTrailing: CGFloat = -16
        static let collectionBottom: CGFloat = -16
        
        static let itemWidth: CGFloat = 108
        static let itemHeight: CGFloat = 192
        
        static let interItemSpacing: CGFloat = 10
        static let lineSpacing: CGFloat = 8
        
        static let itemsPerRow: Int = 3
    }
    
    // MARK: - Properties
    private let presenter: NFTCollectionPresenterProtocol
    private var collectionViewHeightConstraint: NSLayoutConstraint?

    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var coverImage: UIImageView =  {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Peach")
        image.backgroundColor = .gray 
        image.layer.cornerRadius = 12
        image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .headline3
        label.textAlignment = .left
        label.text = "Collection Name"
        return label
    }()
    
    private lazy var webLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption1
        label.textAlignment = .left
        label.text = "Author Name"
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption2
        label.textAlignment = .left
        label.text = "Автор коллекции:"
        return label
    }()
    
    private lazy var authorStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [authorLabel, webLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = CollectionLayout.authorSpacing
        return stack
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption2
        label.numberOfLines = 0
        label.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей." // Placeholder text
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = CollectionLayout.interItemSpacing
        layout.minimumLineSpacing = CollectionLayout.lineSpacing
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = false
        return collection
    }()
    
    // MARK: - Init
    init(presenter: NFTCollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationBackButton()
        setupScrollView()
        setupUIInsideContent()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func setupUIInsideContent() {
        contentView.addSubview(coverImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorStack)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(collectionView)
        
        collectionView.register(NFTCell.self)
        
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImage.heightAnchor.constraint(equalToConstant: CollectionLayout.coverImageHeight),
            
            titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: CollectionLayout.titleTop),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CollectionLayout.titleLeading),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: CollectionLayout.titleTrailing),
            
            authorStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: CollectionLayout.authorTop),
            authorStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorStack.bottomAnchor, constant: CollectionLayout.descriptionTop),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: CollectionLayout.collectionTop),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CollectionLayout.collectionLeading),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: CollectionLayout.collectionTrailing),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CollectionLayout.collectionBottom)
        ])
    }
    
    private func setupNavigationBackButton() {
        let barButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backButtonAction))
        navigationItem.leftBarButtonItem = barButton
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func updateCollectionViewHeight() {
        let itemsPerRow = CollectionLayout.itemsPerRow
        let itemHeight = CollectionLayout.itemHeight
        let verticalSpacing = CollectionLayout.lineSpacing
        
        let itemsCount = presenter.nftCount
        let rows = Int(ceil(Double(itemsCount) / Double(itemsPerRow)))
        let totalHeight = CGFloat(rows) * itemHeight + CGFloat(max(0, rows - 1)) * verticalSpacing
        
        if collectionViewHeightConstraint == nil {
            collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: totalHeight)
            collectionViewHeightConstraint?.isActive = true
        } else {
            collectionViewHeightConstraint?.constant = totalHeight
        }
        
        view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    @objc private func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - NFTCollectionViewProtocol
extension NFTCollectionViewController: NFTCollectionViewProtocol {
    func reloadCollectionView() {
        collectionView.reloadData()
        updateCollectionViewHeight()
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension NFTCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.nftCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configure() 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CollectionLayout.itemWidth, height: CollectionLayout.itemHeight)
    }
}


import UIKit

final class CatalogCell: UITableViewCell, ReuseIdentifying {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private enum CatalogCellLayout {
        static let imageTop: CGFloat = 20
        static let imageHeight: CGFloat = 140
        static let labelTop: CGFloat = 4
        static let labelBottom: CGFloat = -1
        static let imageCornerRadius: CGFloat = 12
    }
    
    //MARK: - UI
    private lazy var catalogImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = CatalogCellLayout.imageCornerRadius
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .whiteUniversal
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var catalogLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .blackUniversal
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        setupImage()
        setupLabel()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setupImage() {
        contentView.addSubview(catalogImage)
        
        NSLayoutConstraint.activate([
            catalogImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CatalogCellLayout.imageTop),
            catalogImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            catalogImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            catalogImage.heightAnchor.constraint(equalToConstant: CatalogCellLayout.imageHeight)
        ])
    }
    
    private func setupLabel() {
        contentView.addSubview(catalogLabel)
        
        NSLayoutConstraint.activate([
            catalogLabel.topAnchor.constraint(equalTo: catalogImage.bottomAnchor, constant: CatalogCellLayout.labelTop),
            catalogLabel.leadingAnchor.constraint(equalTo: catalogImage.leadingAnchor),
            catalogLabel.trailingAnchor.constraint(equalTo: catalogImage.trailingAnchor),
            catalogLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CatalogCellLayout.labelBottom)
        ])
    }
    
    //MARK: - Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        catalogImage.image = nil
        catalogLabel.text = nil
    }
    
    func configure(imageName: String, text: String, numberOfNfts: Int) {
        catalogImage.image = UIImage(named: imageName)
        catalogLabel.text = "\(text.capitalized) (\(numberOfNfts))"
    }
}


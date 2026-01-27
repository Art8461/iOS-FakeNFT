//
//  OnboardingViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 27.01.2026.
//

import UIKit

final class OnboardingViewController: UIViewController {
    var onFinish: (() -> Void)?

    struct Item {
        let title: String
        let subtitle: String
        let image: UIImage?
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()

    private let cellReuseIdentifier = OnboardingImageCell.reuseIdentifier

    private let pageControl: LinePageControl = {
        let pageControl = LinePageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(resource: .close).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(resource: .whiteUniversal)
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitle("Что внутри?", for: .normal)
        button.backgroundColor = UIColor(resource: .blackUniversal)
        button.setTitleColor(UIColor(resource: .whiteUniversal), for: .normal)
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    private let items: [Item] = [
        Item(
            title: NSLocalizedString("Исследуйте", comment: "onboarding title 1"),
            subtitle: NSLocalizedString("Присоединяйтесь и откройте новый мир \nуникальных NFT для коллекционеров", comment: "onboarding subtitle 1"),
            image: UIImage(resource: .onboard1)
        ),
        Item(
            title: NSLocalizedString("Коллекционируйте", comment: "onboarding title 2"),
            subtitle: NSLocalizedString("Пополняйте свою коллекцию эксклюзивными \nкартинками, созданными нейросетью!", comment: "onboarding subtitle 2"),
            image: UIImage(resource: .onboard2)
        ),
        Item(
            title: NSLocalizedString("Состязайтесь", comment: "onboarding title 3"),
            subtitle: NSLocalizedString("Смотрите статистику других и покажите всем, \nчто у вас самая ценная коллекция", comment: "onboarding subtitle 3"),
            image: UIImage(resource: .onboard3)
        )
    ]

    private var currentIndex: Int = 0 {
        didSet {
            updateControls()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .whiteApp)

        collectionView.register(OnboardingImageCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self

        pageControl.numberOfItems = items.count

        layoutViews()
        updateControls()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let size = collectionView.bounds.size
        if layout.itemSize != size {
            layout.itemSize = size
            layout.invalidateLayout()
        }
    }

    private func layoutViews() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(closeButton)
        view.addSubview(actionButton)

        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            closeButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 0),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -66)
        ])
    }

    private func updateControls() {
        pageControl.selectedItem = currentIndex
        actionButton.isHidden = currentIndex != items.count - 1
    }

    @objc
    private func actionButtonTapped() {
        onFinish?()
    }

    @objc
    private func closeButtonTapped() {
        onFinish?()
    }
}

// MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseIdentifier,
            for: indexPath
        )
        let item = items[indexPath.item]
        if let cell = cell as? OnboardingImageCell {
            cell.configure(with: item)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension OnboardingViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentIndex()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentIndex()
    }

    private func updateCurrentIndex() {
        guard collectionView.bounds.width > 0 else { return }
        let rawIndex = collectionView.contentOffset.x / collectionView.bounds.width
        let index = Int(round(rawIndex))
        currentIndex = min(max(index, 0), items.count - 1)
    }
}

private final class OnboardingImageCell: UICollectionViewCell {
    static let reuseIdentifier = "OnboardingImageCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(resource: .whiteUniversal)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(resource: .whiteUniversal)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(textStack)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 230),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    func configure(with item: OnboardingViewController.Item) {
        imageView.image = item.image
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
}

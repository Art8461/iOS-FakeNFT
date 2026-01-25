import UIKit

final class CatalogViewController: UIViewController {
    // MARK: - UI
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Dependencies
    private var presenter: CatalogViewOutput!
    
    // MARK: - Data for table
    private var items: [Catalog] = []
    
    // MARK: - Init
    init(catalogProvider: CatalogProviderProtocol) {
        super.init(nibName: nil, bundle: nil)
        let presenter = CatalogPresenter(view: self, catalogProvider: catalogProvider)
        self.presenter = presenter
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
}

// MARK: - Setup UI
private extension CatalogViewController {
    func setupUI() {
        view.backgroundColor = .backgroundUniversal
        
        setupTableView()
        setupActivityIndicator()
        setupNavigationItems()
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.reuseIdentifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupNavigationItems() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "By Name",
                            style: .plain,
                            target: self,
                            action: #selector(sortByNameTapped)),
            UIBarButtonItem(title: "By Count",
                            style: .plain,
                            target: self,
                            action: #selector(sortByCountTapped))
        ]
    }
    
    @objc func sortByNameTapped() {
        presenter.didTapSortByName()
    }
    
    @objc func sortByCountTapped() {
        presenter.didTapSortByCount()
    }
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogCell.reuseIdentifier,
            for: indexPath
        ) as? CatalogCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.configure(imageName: item.cover, text: item.name, numberOfNfts: item.nfts.count)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectItem(at: indexPath.row)
    }
}

// MARK: - CatalogViewInput
extension CatalogViewController: CatalogViewInput {
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    func showCatalog(_ items: [Catalog]) {
        self.items = items
        tableView.reloadData()
    }
}




import UIKit

final class CatalogViewController: UIViewController {
    // MARK: - UI
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - MVP Dependencies
    // MVP: презентер (output) инжектится извне через сборку.
    private let output: CatalogViewOutput
    
    // MARK: - Data
    private var items: [Catalog] = []
    
    // MARK: - Init
    // MVP: зависимости резолвятся вне view.
    init(output: CatalogViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.viewDidLoad()
    }
}

    // MARK: - Setup UI
    private extension CatalogViewController {
    func setupUI() {
        view.backgroundColor = .whiteApp
        
        setupTableView()
        setupActivityIndicator()
        setupNavigationItems()
    }
    
    // Настройка таблицы
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
    
    // Настройка индикатора
    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // Настройка navigation bar
    func setupNavigationItems() {
        let sortImage = UIImage(resource: .sort)
        let sortButton = UIBarButtonItem(
            image: sortImage,
            style: .plain,
            target: self,
            action: #selector(showSortOptions)
        )
        
        navigationItem.rightBarButtonItem = sortButton
    }
    
    // Алерт. Логика обработки нажатий
    @objc
    func showSortOptions() {
        
        // UIAlertController c типом .actionSheet
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        // Действие "Сортировать по имени"
        let sortByNameAction = UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            self?.output.didTapSortByName()
        }
        
        // Действие "Сортировать по количеству NFT"
        let sortByCountAction = UIAlertAction(title: "По количеству NFT", style: .default) { [weak self] _ in
            self?.output.didTapSortByCount()
        }
        
        // Действие "Отмена"
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(sortByNameAction)
        alert.addAction(sortByCountAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

    // MARK: - UITableViewDataSource
    extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // Возвращает ячейку для строки по указанному indexPath
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
        output.didSelectItem(at: indexPath.row)
    }
}

    // MARK: - CatalogViewInput
    extension CatalogViewController: CatalogViewInput {
    
    // Показывает или скрывает индикатор загрузки.
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // Отображает пользователю сообщение об ошибке
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    // Обновляет таблицу, отображая полученный список элементов каталога
    func showCatalog(_ items: [Catalog]) {
        self.items = items
        tableView.reloadData()
    }
}







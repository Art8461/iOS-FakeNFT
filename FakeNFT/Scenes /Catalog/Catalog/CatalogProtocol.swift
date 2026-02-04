import Foundation

// Протокол для представления (View), который определяет методы для обновления интерфейса.
protocol CatalogViewInput: AnyObject {
    func setLoading(_ isLoading: Bool)
    func showError(_ error: Error)
    func showCatalog(_ items: [Catalog])
}

// Протокол для вывода (Output) от представления к презентеру.
protocol CatalogViewOutput: AnyObject {
    func viewDidLoad()
    func didTapSortByName()
    func didTapSortByCount()
    func didSelectItem(at index: Int)
}

// Протокол для провайдера данных, который отвечает за загрузку каталога.
protocol CatalogProviderProtocol {
    func loadCatalog() throws -> [Catalog]
}

protocol CatalogRouterInput: AnyObject {
    func openCollection(_ collection: Catalog)
}


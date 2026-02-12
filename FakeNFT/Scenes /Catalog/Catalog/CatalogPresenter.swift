import UIKit

final class CatalogPresenter {
    weak var view: CatalogViewInput?
    private let catalogProvider: CatalogProviderProtocol
    private let router: CatalogRouterInput
    
    private var catalog: [Catalog] = []
    
    init(
        catalogProvider: CatalogProviderProtocol,
        router: CatalogRouterInput
    ) {
        self.catalogProvider = catalogProvider
        self.router = router
    }
}

// MARK: - CatalogViewOutput
extension CatalogPresenter: CatalogViewOutput {
    func viewDidLoad() {
        loadData()
    }
    
    func didTapSortByName() {
        catalog = catalog.sorted { $0.name < $1.name }
        view?.showCatalog(catalog)
    }
    
    func didTapSortByCount() {
        catalog = catalog.sorted { $0.nfts.count > $1.nfts.count }
        view?.showCatalog(catalog)
    }
    
    func didSelectItem(at index: Int) {
        let item = catalog[index]
        router.openCollection(item)
    }
}


// MARK: - Private Methods
private extension CatalogPresenter {
    
    func loadData() {
        view?.setLoading(true)
        
        defer {
            view?.setLoading(false)
        }
        
        do {
            let catalogData = try catalogProvider.loadCatalog()
            self.catalog = catalogData
            self.view?.showCatalog(catalogData)
        } catch {
            self.view?.showError(error)
        }
    }
}

// MARK: - Catalog Router
final class CatalogRouter: CatalogRouterInput {
    weak var viewController: UIViewController?
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func openCollection(_ collection: Catalog) {
        let builder = NFTCollectionModuleBuilder(servicesAssembly: servicesAssembly)
        let collectionVC = builder.build(with: collection)
        viewController?.navigationController?.pushViewController(collectionVC, animated: true)
    }
}

// MARK: - Catalog Assembly
final class CatalogAssembly {
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build() -> UIViewController {
        let router = CatalogRouter(servicesAssembly: servicesAssembly)
        let presenter = CatalogPresenter(
            catalogProvider: servicesAssembly.catalogProvider,
            router: router
        )
        let viewController = CatalogViewController(output: presenter)
        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }
}




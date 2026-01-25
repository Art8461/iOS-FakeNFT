import Foundation

final class CatalogPresenter {
    private weak var view: CatalogViewInput?
   
    private let catalogProvider: CatalogProviderProtocol
    
    private var catalog: [Catalog] = []
    
    init(view: CatalogViewInput,
         catalogProvider: CatalogProviderProtocol) {
        self.view = view
        self.catalogProvider = catalogProvider
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
//        let item = catalog[index]
       
    }
}

// MARK: - Private Methods
private extension CatalogPresenter {
    
    // CatalogPresenter.swift
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




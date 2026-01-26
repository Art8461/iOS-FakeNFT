import Foundation

struct EmptyCatalogProvider: CatalogProviderProtocol {
    func loadCatalog() throws -> [Catalog] {
        return []
    }
}







import Foundation

struct CatalogMockProvider: CatalogProviderProtocol {
    func loadCatalog() throws -> [Catalog] {
        [
            Catalog(
                name: "Neo City",
                cover: "Catalog",
                nfts: ["nft_1", "nft_2", "nft_3"],
                description: "Mock collection for catalog demo.",
                author: "Demo Author",
                id: "collection_1"
            ),
            Catalog(
                name: "Abstract Shapes",
                cover: "StarsActive",
                nfts: ["nft_4", "nft_5"],
                description: "Mock collection for catalog demo.",
                author: "Demo Author",
                id: "collection_2"
            ),
            Catalog(
                name: "Pixel Heroes",
                cover: "Basket",
                nfts: ["nft_6"],
                description: "Mock collection for catalog demo.",
                author: "Demo Author",
                id: "collection_3"
            )
        ]
    }
}

import Foundation

struct EmptyCatalogProvider: CatalogProviderProtocol {
    func loadCatalog() throws -> [Catalog] {
        return []
    }
}






//enum CatalogMockData {
//    static func makeCatalog() -> [Catalog] {
//        return [
//            Catalog(
//                name: "Cyberpunk Collection",
//                cover: URL(string: "https://picsum.photos/300/200?random=1")!,
//                nfts: ["nft_1", "nft_2", "nft_3"],
//                description: "Неоновый киберпанк из будущего.",
//                author: "John Doe",
//                id: "collection_1"
//            ),
//            Catalog(
//                name: "Abstract Shapes",
//                cover: URL(string: "https://picsum.photos/300/200?random=2")!,
//                nfts: ["nft_4", "nft_5"],
//                description: "Абстрактные формы и яркие цвета.",
//                author: "Jane Smith",
//                id: "collection_2"
//            ),
//            Catalog(
//                name: "Pixel Heroes",
//                cover: URL(string: "https://picsum.photos/300/200?random=3")!,
//                nfts: ["nft_6"],
//                description: "Пиксельные персонажи в ретро‑стиле.",
//                author: "PixelMan",
//                id: "collection_3"
//            )
//        ]
//    }
//}
//

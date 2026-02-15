import Foundation

struct FavoriteNftMockProvider: FavoriteNftProvider {
    func getFavoriteIds() -> [String] {
        [
            "nft_1",
            "nft_3",
            "nft_5"
        ]
    }

    func addToFavorites(id: String) {
      
        print("Mock: addToFavorites(\(id))")
    }

    func removeFromFavorites(id: String) {

        print("Mock: removeFromFavorites(\(id))")
    }
}

final class OrderNftMockProvider: OrderNftProvider {

    private var cart: [String] = [
        "nft_2",
        "nft_4"
    ]

    func getCartIds() -> [String] {
        cart
    }

    func addToCart(id: String) {
        guard !cart.contains(id) else { return }
        cart.append(id)
        print("Mock: addToCart(\(id))")
    }

    func removeFromCart(id: String) {
        cart.removeAll { $0 == id }
        print("Mock: removeFromCart(\(id))")
    }
}

// MARK: - Мок-сервисы
//final class NftListMockService: NftListService {
//    func loadNfts(ids: [String], completion: @escaping (Result<[Nft], Error>) -> Void) {
//        let nfts = ids.map { id in
//            Nft(
//                name: "NFT \(id)",
//                images: [Self.makeImageUrl(for: id)],
//                rating: 4,
//                description: "Mock NFT for catalog demo.",
//                price: 1.0,
//                author: "Demo Author123",
//                id: id
//            )
//        }
//        completion(.success(nfts))
//    }
//
//    private static func makeImageUrl(for id: String) -> URL {
//        // Моки используют asset://, обработка в view.
//        let assetName: String
//        switch id {
//        case "nft_1", "nft_2", "nft_3":
//            assetName = "Catalog"
//        case "nft_4", "nft_5":
//            assetName = "StarsActive"
//        default:
//            assetName = "Basket"
//        }
//        return URL(string: "asset://\(assetName)") ?? URL(fileURLWithPath: "/")
//    }
//}

final class FavoriteNftMockService: FavoriteNftService {
    private let storage: FavoriteNftProvider
    private var favorites: [String]

    init(storage: FavoriteNftProvider) {
        self.storage = storage
        self.favorites = storage.getFavoriteIds()
    }

    func getFavorites(completion: @escaping (Result<[String], Error>) -> Void) {
        completion(.success(favorites))
    }

    func toggleFavorite(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        if let index = favorites.firstIndex(of: id) {
            favorites.remove(at: index)
            storage.removeFromFavorites(id: id)
        } else {
            favorites.append(id)
            storage.addToFavorites(id: id)
        }
        completion(.success(favorites))
    }
}

final class OrderNftMockService: OrderNftService {
    private let storage: OrderNftProvider
    private var cart: [String]

    init(storage: OrderNftProvider) {
        self.storage = storage
        self.cart = storage.getCartIds()
    }

    func getCart(completion: @escaping (Result<[String], Error>) -> Void) {
        completion(.success(cart))
    }

    func toggleInCart(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        if let index = cart.firstIndex(of: id) {
            cart.remove(at: index)
            storage.removeFromCart(id: id)
        } else {
            cart.append(id)
            storage.addToCart(id: id)
        }
        completion(.success(cart))
    }
}

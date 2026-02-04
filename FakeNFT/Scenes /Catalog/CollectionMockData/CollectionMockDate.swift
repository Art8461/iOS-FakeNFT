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



import Foundation

// Протокол входа во View
protocol NFTCollectionViewInput: AnyObject {
    func showLoading(_ isLoading: Bool)
    func showError(_ error: Error)
    func updateNfts(_ nfts: [Nft])
    func updateFavorites(_ favorites: [String])
    func updateCart(_ itemsInCart: [String])
}

// Протокол выхода из View
protocol NFTCollectionViewOutput: AnyObject {
    func viewDidLoad()
    func didTapBack()
    func didSelectNft(with id: String)
    func didToggleFavorite(for id: String)
    func didToggleCart(for id: String)
}

// Провайдер для работы с хранилищем/источником данных избранных NFT
protocol FavoriteNftProvider {
    func getFavoriteIds() -> [String]
    func addToFavorites(id: String)
    func removeFromFavorites(id: String)
}

// Провайдер для работы с хранилищем/источником данных корзины
protocol OrderNftProvider {
    func getCartIds() -> [String]
    func addToCart(id: String)
    func removeFromCart(id: String)
}

// Сервис для загрузки списка NFT по их id
protocol NftListService {
    func loadNfts(ids: [String], completion: @escaping (Result<[Nft], Error>) -> Void)
}

// Сервис избранного
protocol FavoriteNftService {
    func getFavorites(completion: @escaping (Result<[String], Error>) -> Void)
    func toggleFavorite(id: String, completion: @escaping (Result<[String], Error>) -> Void)
}

// Сервис корзины
protocol OrderNftService {
    func getCart(completion: @escaping (Result<[String], Error>) -> Void)
    func toggleInCart(id: String, completion: @escaping (Result<[String], Error>) -> Void)
}

// Роутер для навигации с экрана коллекции NFT
protocol NFTCollectionRouter {
    func close()
    func showNftDetail(id: String)
}

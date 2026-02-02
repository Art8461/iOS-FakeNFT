import Foundation

protocol NFTCollectionViewInput: AnyObject {
  func showLoading(_ isLoading: Bool)
  func showError(_ error: Error)
  func updateNfts(_ nfts: [Nft])
  func updateFavorites(_ favorites: [String])
  func updateCart(_ itemsInCart: [String])
}

protocol NFTCollectionViewOutput: AnyObject {
  func viewDidLoad()
  func didTapBack()
  func didSelectNft(with id: String)
  func didToggleFavorite(for id: String)
  func didToggleCart(for id: String)
}

protocol FavoriteNftProvider {
  func getFavoriteIds() -> [String]
  func addToFavorites(id: String)
  func removeFromFavorites(id: String)
}

import Foundation

protocol OrderNftProvider {
  func getCartIds() -> [String]
  func addToCart(id: String)
  func removeFromCart(id: String)
}



import UIKit

final class NFTCollectionModuleBuilder {
  // MVP: сборка модуля вынесена из view controller.
  private let servicesAssembly: ServicesAssembly

  init(servicesAssembly: ServicesAssembly) {
    self.servicesAssembly = servicesAssembly
  }

  func build(with collection: Catalog) -> UIViewController {
    let viewController = NFTCollectionViewController(collection: collection)
    let router = NFTCollectionRouterImpl(
      viewController: viewController,
      servicesAssembly: servicesAssembly
    )
    let presenter = NFTCollectionPresenter(
      view: viewController,
      nftService: NftListMockService(),
      favoriteService: FavoriteNftMockService(storage: servicesAssembly.favoriteNftProvider),
      orderService: OrderNftMockService(storage: servicesAssembly.orderNftProvider),
      router: router,
      nftIds: collection.nfts
    )
    viewController.output = presenter
    return viewController
  }
}

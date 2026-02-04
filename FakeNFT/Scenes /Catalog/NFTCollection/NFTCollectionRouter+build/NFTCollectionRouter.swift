import UIKit

final class NFTCollectionRouterImpl: NFTCollectionRouter {
  // MVP: роутинг отделён от view controller.
  private weak var viewController: UIViewController?
  private let servicesAssembly: ServicesAssembly

  init(viewController: UIViewController, servicesAssembly: ServicesAssembly) {
    self.viewController = viewController
    self.servicesAssembly = servicesAssembly
  }

  func close() {
    viewController?.navigationController?.popViewController(animated: true)
  }

  func showNftDetail(id: String) {
    let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
    let input = NftDetailInput(id: id)
    let detailsVC = assembly.build(with: input)
    viewController?.navigationController?.pushViewController(detailsVC, animated: true)
  }
}

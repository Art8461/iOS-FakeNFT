import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        configureNavigationBarAppearance()

        let window = UIWindow(windowScene: windowScene)
        let rootViewController: UIViewController
        if servicesAssembly.authService.isAuthorized {
            rootViewController = TabBarController(servicesAssembly: servicesAssembly)
        } else {
            rootViewController = AuthAssembly(servicesAssembly: servicesAssembly).build()
        }
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }

    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let backImage = UIImage(resource: .backward)
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear
        ]
        appearance.backButtonAppearance = backButtonAppearance

        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.tintColor = UIColor(resource: .blackApp)
    }
}

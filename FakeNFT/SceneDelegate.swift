import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    private enum OnboardingStorage {
        static let hasSeenKey = "hasSeenOnboarding"
    }

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = makeRootViewController(window: window)
        window.makeKeyAndVisible()
        self.window = window
    }

    private func makeRootViewController(window: UIWindow) -> UIViewController {
        if UserDefaults.standard.bool(forKey: OnboardingStorage.hasSeenKey) {
            return TabBarController(servicesAssembly: servicesAssembly)
        }

        let onboardingViewController = OnboardingAssembly().build()
        onboardingViewController.onFinish = { [weak self, weak window] in
            guard let self, let window else { return }
            UserDefaults.standard.set(true, forKey: OnboardingStorage.hasSeenKey)
            window.rootViewController = TabBarController(servicesAssembly: self.servicesAssembly)
        }

        return onboardingViewController
    }
}

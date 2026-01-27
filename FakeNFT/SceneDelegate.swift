import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private static let onboardingHasSeenKey = "Onboarding.hasSeen"

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        configureNavigationBarAppearance()

        let window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
        self.window = window

        if hasSeenOnboarding {
            showMainFlow(in: window)
        } else {
            showOnboarding(in: window)
        }
    }

    private func showOnboarding(in window: UIWindow) {
        let onboardingViewController = OnboardingAssembly().build()
        onboardingViewController.onFinish = { [weak self, weak window] in
            guard let self, let window else { return }
            self.markOnboardingSeen()
            self.showMainFlow(in: window)
        }
        window.rootViewController = onboardingViewController
    }

    private var hasSeenOnboarding: Bool {
        UserDefaults.standard.bool(forKey: Self.onboardingHasSeenKey)
    }

    private func markOnboardingSeen() {
        UserDefaults.standard.set(true, forKey: Self.onboardingHasSeenKey)
    }

    private func showMainFlow(in window: UIWindow) {
        let rootViewController: UIViewController
        if servicesAssembly.authService.isAuthorized {
            rootViewController = TabBarController(servicesAssembly: servicesAssembly)
        } else {
            rootViewController = AuthAssembly(servicesAssembly: servicesAssembly).build()
        }
        UIView.transition(
            with: window,
            duration: 0.25,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = rootViewController
            }
        )
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

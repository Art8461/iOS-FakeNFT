import UIKit

final class TestCatalogViewController: UIViewController, ErrorView {

    let servicesAssembly: ServicesAssembly
    let testNftButton = UIButton()

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(resource: .whiteApp)

        view.addSubview(testNftButton)
        testNftButton.constraintCenters(to: view)
        testNftButton.setTitle(Constants.openNftTitle, for: .normal)
        testNftButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        testNftButton.setTitleColor(.systemBlue, for: .normal)
    }

    @objc
    func signOut() {
        do {
            try servicesAssembly.authService.signOut()
            showAuth()
        } catch {
            let primary = ErrorAction(
                title: NSLocalizedString("Error.close", comment: ""),
                style: .cancel
            ) { }
            let model = ErrorModel(
                message: NSLocalizedString("Error.unknown", comment: ""),
                primaryAction: primary,
                secondaryAction: nil
            )
            showError(model)
        }
    }

    private func showAuth() {
        let authViewController = AuthAssembly(servicesAssembly: servicesAssembly).build()
        guard let window = resolveWindow() else { return }

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = authViewController
        }
    }

    private func resolveWindow() -> UIWindow? {
        if let window = view.window {
            return window
        }
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

private enum Constants {
    static let openNftTitle = NSLocalizedString("Catalog.openNft", comment: "")
}

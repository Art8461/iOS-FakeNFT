import UIKit

struct ErrorModel {
    let title: String?
    let message: String
    let primaryAction: ErrorAction
    let secondaryAction: ErrorAction?

    init(
        title: String? = nil,
        message: String,
        primaryAction: ErrorAction,
        secondaryAction: ErrorAction? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
}

struct ErrorAction {
    let title: String
    let style: UIAlertAction.Style
    let handler: () -> Void
}

protocol ErrorView {
    func showError(_ model: ErrorModel)
}

extension ErrorView where Self: UIViewController {

    func showError(_ model: ErrorModel) {
        let title = model.title ?? NSLocalizedString("Error.title", comment: "")
        let alert = UIAlertController(title: title, message: model.message, preferredStyle: .alert)

        let primary = UIAlertAction(title: model.primaryAction.title,
                                    style: model.primaryAction.style) { _ in
            model.primaryAction.handler()
        }
        alert.addAction(primary)

        if let secondary = model.secondaryAction {
            let secondaryAction = UIAlertAction(title: secondary.title,
                                                style: secondary.style) { _ in
                secondary.handler()
            }
            alert.addAction(secondaryAction)
        }

        present(alert, animated: true)
    }
}

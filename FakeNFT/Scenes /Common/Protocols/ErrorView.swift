import UIKit

struct ErrorModel {
    let message: String
    let primaryAction: ErrorAction
    let secondaryAction: ErrorAction?
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
        let title = NSLocalizedString("Error.title", comment: "")
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

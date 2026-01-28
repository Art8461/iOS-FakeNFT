//
//  SortActionSheetViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 28.01.2026.
//

import UIKit

struct SortActionSheetOption {
    let title: String
    let handler: () -> Void
}

final class SortActionSheetViewController: NSObject {
    
    // MARK: - Properties
    
    lazy var barButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: UIImage(resource: .sort),
            style: .plain,
            target: self,
            action: #selector(didTapSort)
        )
        item.tintColor = UIColor(resource: .blackApp)
        return item
    }()
    
    // MARK: - Private properties
    
    private weak var presentingViewController: UIViewController?
    private let options: [SortActionSheetOption]
    
    // MARK: - Init
    
    init(presentingViewController: UIViewController, options: [SortActionSheetOption]) {
        self.presentingViewController = presentingViewController
        self.options = options
        super.init()
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapSort() {
        let controller = UIAlertController(
            title: NSLocalizedString("Сортировка", comment: "sort action sheet title"),
            message: nil,
            preferredStyle: .actionSheet
        )
        options.forEach { option in
            let action = UIAlertAction(
                title: option.title,
                style: .default
            ) { _ in
                option.handler()
            }
            controller.addAction(action)
        }
        let cancel = UIAlertAction(
            title: NSLocalizedString("Закрыть", comment: "cancel sort"),
            style: .cancel
        )
        controller.addAction(cancel)
        
        if let popover = controller.popoverPresentationController {
            popover.barButtonItem = barButtonItem
        }
        presentingViewController?.present(controller, animated: true)
    }
}

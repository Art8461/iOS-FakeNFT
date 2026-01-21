//
//  BasketPresenter.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 21.01.2026.
//

import UIKit

protocol BasketView: AnyObject {
    func display(isEmpty: Bool)
}

protocol BasketPresenter {
    func viewDidLoad()
    func didTapSort()
}

final class BasketPresenterImpl: BasketPresenter {
    weak var view: BasketView?
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func viewDidLoad() {
        view?.display(isEmpty: true)
    }

    func didTapSort() {
        // TODO: сортировка позже
    }
}

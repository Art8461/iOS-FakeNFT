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
    private let basketService: BasketService
    
    init(basketService: BasketService) {
        self.basketService = basketService
    }
    
    func viewDidLoad() {
        basketService.loadOrder { [weak self] result in
            switch result {
            case .success(let order):
                self?.view?.display(isEmpty: order.nfts.isEmpty)
                // self?.nftIds = order.nfts
            case .failure:
                self?.view?.display(isEmpty: true)
            }
        }
    }
    
    func didTapSort() {
        // TODO: сортировка позже
    }
}

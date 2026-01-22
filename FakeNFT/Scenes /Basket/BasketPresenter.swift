//
//  BasketPresenter.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 21.01.2026.
//

import UIKit

protocol BasketView: AnyObject {
    func display(isEmpty: Bool)
    func display(items: [BasketItemCellModel])
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
        self.nftService = nftService
    }
    
    func viewDidLoad() {
        basketService.loadOrder { [weak self] result in
            switch result {
            case .success(let order):
                self?.view?.display(isEmpty: order.nfts.isEmpty)
                self?.loadNfts(ids: order.nfts)
            case .failure:
                self?.view?.display(isEmpty: true)
            }
        }
    }
    
    private func loadNfts(ids: [String]) {
        guard !ids.isEmpty else {
            view?.display(items: [])
            return
        }
        
        let group = DispatchGroup()
        var nftsById: [String: Nft] = [:]
        var firstError: Error?
        
        ids.forEach { id in
            group.enter()
            nftService.loadNft(id: id) { result in
                defer { group.leave() }
                switch result {
                case .success(let nft):
                    nftsById[id] = nft
                case .failure(let error):
                    if firstError == nil { firstError = error }
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            if let _ = firstError, nftsById.isEmpty {
                self.view?.display(isEmpty: true)
                return
            }
            
            let orderedNfts = ids.compactMap { nftsById[$0] }
            let models = orderedNfts.map { nft in
                BasketItemCellModel(
                    id: nft.id,
                    title: nft.name,
                    priceText: String(format: "%.2f ETH", nft.price),
                    rating: nft.rating,
                    imageURL: nft.images.first
                )
            }
            
            self.view?.display(items: models)
            self.view?.display(isEmpty: models.isEmpty)
        }
    }
    
    func didTapSort() {
        // TODO: сортировка позже
    }
}

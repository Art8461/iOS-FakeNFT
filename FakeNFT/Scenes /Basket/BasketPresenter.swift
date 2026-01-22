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
    func display(summary: BasketSummaryViewModel)
}

protocol BasketPresenter {
    func viewDidLoad()
    func refresh()
    func didTapSort()
    func didTapDelete(id: String)
}

final class BasketPresenterImpl: BasketPresenter {
    
    private var nftIds: [String] = []

    func didTapDelete(id: String) {
        nftIds.removeAll { $0 == id }
        updateOrder()
    }
    
    func refresh() {
        reloadOrder()
    }
    
    private func reloadOrder() {
        basketService.loadOrder { [weak self] result in
            switch result {
            case .success(let order):
                self?.nftIds = order.nfts
                if order.nfts.isEmpty {
                    self?.view?.display(isEmpty: true)
                    self?.view?.display(items: [])
                    return
                }
                self?.view?.display(isEmpty: false)
                self?.loadNfts(ids: order.nfts)
            case .failure:
                self?.view?.display(isEmpty: true)
            }
        }
    }
    
    private func updateOrder() {
        basketService.updateOrder(nfts: nftIds) { [weak self] result in
            switch result {
            case .success(let order):
                self?.nftIds = order.nfts
                if order.nfts.isEmpty {
                    self?.view?.display(isEmpty: true)
                    self?.view?.display(items: [])
                    return
                }
                self?.view?.display(isEmpty: false)
                self?.loadNfts(ids: order.nfts)
            case .failure:
                // обработать ошибку
                break
            }
        }
    }
    
    weak var view: BasketView?
    private let basketService: BasketService
    private let nftService: NftService
    
    init(basketService: BasketService, nftService: NftService) {
        self.basketService = basketService
        self.nftService = nftService
    }
    
    func viewDidLoad() {
        view?.display(isEmpty: true)
    }
    
    private func loadNfts(ids: [String]) {
        guard !ids.isEmpty else {
            view?.display(items: [])
            view?.display(isEmpty: true)
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
            
            let count = orderedNfts.count
            let total = orderedNfts.reduce(0.0) { $0 + $1.price }

            let summary = BasketSummaryViewModel(
                countText: "\(count) NFT",
                totalText: String(format: "%.2f ETH", total)
            )

            self.view?.display(summary: summary)
            
            self.view?.display(items: models)
            self.view?.display(isEmpty: models.isEmpty)
        }
    }
    
    func didTapSort() {
        // TODO: сортировка позже
    }
}

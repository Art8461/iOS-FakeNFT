//
//  BasketPresenter.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 21.01.2026.
//

import Foundation

protocol BasketView: AnyObject, ErrorView {
    func display(isEmpty: Bool)
    func display(items: [BasketItemCellModel])
    func display(summary: BasketSummaryViewModel)
    func displayLoading(_ isLoading: Bool)
}

protocol BasketPresenter {
    func viewDidLoad()
    func refresh()
    func didSelectSort(option: BasketSortOption)
    func didTapDelete(id: String)
    func didTapPay()
    var orderId: String? { get }
}

enum BasketSortOption {
    case price
    case rating
    case name
}

final class BasketPresenterImpl: BasketPresenter {
    
    weak var view: BasketView?
    private let basketService: BasketService
    private let nftService: NftService
    private let router: BasketRouting
    
    init(basketService: BasketService, nftService: NftService, router: BasketRouting) {
        self.basketService = basketService
        self.nftService = nftService
        self.router = router
    }
    
    internal var orderId: String?
    private var nftIds: [String] = []
    private var currentNfts: [Nft] = []
    private var sortOption: BasketSortOption?

    func didTapDelete(id: String) {
        let previousIds = nftIds
        let previousNfts = currentNfts

        nftIds.removeAll { $0 == id }
        currentNfts.removeAll { $0.id == id }
        applySortAndDisplay()

        updateOrder(removedId: id, previousIds: previousIds, previousNfts: previousNfts)
    }
    
    func refresh() {
        reloadOrder()
    }
    
    func didTapPay() {
        guard let orderId else {
            let primary = ErrorAction(
                title: NSLocalizedString("Error.repeat", comment: ""),
                style: .default
            ) { [weak self] in
                self?.didTapPay()
            }
            let secondary = ErrorAction(
                title: NSLocalizedString("Error.close", comment: ""),
                style: .cancel
            ) { }
            let model = ErrorModel(
                message: NSLocalizedString("Error.network", comment: ""),
                primaryAction: primary,
                secondaryAction: secondary
            )
            self.view?.showError(model)
            return
        }
        router.showPayment(orderId: orderId)
    }
    
    private func reloadOrder() {
        view?.displayLoading(true)
        basketService.loadOrder { [weak self] result in
            DispatchQueue.main.async {
                assert(Thread.isMainThread)

                switch result {
                case .success(let order):
                    self?.orderId = order.id
                    self?.nftIds = order.nfts
                    if order.nfts.isEmpty {
                        self?.currentNfts = []
                        self?.view?.displayLoading(false)
                        self?.view?.display(isEmpty: true)
                        self?.view?.display(items: [])
                        return
                    }
                    self?.loadNfts(ids: order.nfts)
                case .failure:
                    self?.currentNfts = []
                    self?.view?.displayLoading(false)
                    self?.view?.display(isEmpty: true)
                    let primary = ErrorAction(
                        title: NSLocalizedString("Error.repeat", comment: ""),
                        style: .default
                    ) { [weak self] in
                        self?.reloadOrder()
                    }
                    let secondary = ErrorAction(
                        title: NSLocalizedString("Error.close", comment: ""),
                        style: .cancel
                    ) { }
                    let model = ErrorModel(
                        message: NSLocalizedString("Error.network", comment: ""),
                        primaryAction: primary,
                        secondaryAction: secondary
                    )
                    self?.view?.showError(model)
                }
            }
        }
    }
    
    private func updateOrder(removedId: String, previousIds: [String], previousNfts: [Nft]) {
        basketService.updateOrder(nfts: nftIds) { [weak self] result in
            DispatchQueue.main.async{
                assert(Thread.isMainThread)

                switch result {
                case .success(let order):
                    self?.nftIds = order.nfts
                    if order.nfts.isEmpty {
                        self?.currentNfts = []
                        self?.view?.display(isEmpty: true)
                        self?.view?.display(items: [])
                        return
                    }
                    self?.loadNfts(ids: order.nfts)
                case .failure:
                    self?.nftIds = previousIds
                    self?.currentNfts = previousNfts
                    self?.applySortAndDisplay()
                    let primary = ErrorAction(
                        title: NSLocalizedString("Error.repeat", comment: ""),
                        style: .default
                    ) { [weak self] in
                        self?.didTapDelete(id: removedId)
                    }
                    let secondary = ErrorAction(
                        title: NSLocalizedString("Error.close", comment: ""),
                        style: .cancel
                    ) { }
                    let model = ErrorModel(
                        message: NSLocalizedString("Error.network", comment: ""),
                        primaryAction: primary,
                        secondaryAction: secondary
                    )
                    self?.view?.showError(model)
                }
            }
        }
    }
    
    func viewDidLoad() {
        view?.display(isEmpty: true)
    }
    
    private func loadNfts(ids: [String]) {
        guard !ids.isEmpty else {
            DispatchQueue.main.async {
                assert(Thread.isMainThread)

                self.view?.displayLoading(false)
                self.currentNfts = []
                self.view?.display(items: [])
                self.view?.display(isEmpty: true)
            }
                return
        }
        
        let group = DispatchGroup()
        var nftsById: [String: Nft] = [:]
        var tasks: [NetworkTask] = []
        var hasFailed = false
        
        ids.forEach { id in
            group.enter()
            let task = nftService.loadNft(id: id) { [weak self] result in
                defer { group.leave() }
                guard let self else { return }
                if hasFailed { return }
                
                switch result {
                case .success(let nft):
                    nftsById[id] = nft
                case .failure:
                    if hasFailed { return }
                    hasFailed = true
                    tasks.forEach { $0.cancel() }
                    
                    DispatchQueue.main.async {
                        assert(Thread.isMainThread)

                        self.view?.displayLoading(false)
                        let primary = ErrorAction(
                            title: NSLocalizedString("Error.repeat", comment: ""),
                            style: .default
                        ) { [weak self] in
                            self?.loadNfts(ids: ids)
                        }
                        let secondary = ErrorAction(
                            title: NSLocalizedString("Error.close", comment: ""),
                            style: .cancel
                        ) { }
                        let model = ErrorModel(
                            message: NSLocalizedString("Error.partial", comment: ""),
                            primaryAction: primary,
                            secondaryAction: secondary
                        )
                        self.view?.showError(model)
                    }
                }
            }
            if let task { tasks.append(task) }
        }
        
        group.notify(queue: .main) { [weak self] in
            assert(Thread.isMainThread)

            guard let self, !hasFailed else { return }
            self.view?.displayLoading(false)
            let orderedNfts = ids.compactMap { nftsById[$0] }
            self.currentNfts = orderedNfts
            self.applySortAndDisplay()
        }
    }
    
    func didSelectSort(option: BasketSortOption) {
        sortOption = option
        applySortAndDisplay()
    }
    
    private func applySortAndDisplay() {
        let sortedNfts = sorted(currentNfts)
        let models = sortedNfts.map { nft in
            BasketItemCellModel(
                id: nft.id,
                title: nft.name,
                priceText: String(format: "%.2f ETH", nft.price),
                rating: nft.rating,
                imageURL: nft.images.first
            )
        }
        
        let count = currentNfts.count
        let total = currentNfts.reduce(0.0) { $0 + $1.price }
        
        let summary = BasketSummaryViewModel(
            countText: "\(count) NFT",
            totalText: String(format: "%.2f ETH", total)
        )
        
        view?.display(summary: summary)
        view?.display(items: models)
        view?.display(isEmpty: models.isEmpty)
    }
    
    private func sorted(_ nfts: [Nft]) -> [Nft] {
        guard let sortOption = sortOption else { return nfts }
        switch sortOption {
        case .price:
            return nfts.sorted { lhs, rhs in
                if lhs.price == rhs.price {
                    return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
                }
                return lhs.price > rhs.price
            }
        case .rating:
            return nfts.sorted { lhs, rhs in
                if lhs.rating == rhs.rating {
                    return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
                }
                return lhs.rating > rhs.rating
            }
        case .name:
            return nfts.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }
}

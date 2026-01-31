//
//  StatsPresenter.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 28.01.2026.
//

import Foundation

protocol StatsView: AnyObject, ErrorView {
    func display(items: [StatsItemCellModel])
    func displayLoading(_ isLoading: Bool)
}

protocol StatsPresenter {
    func viewDidLoad()
    func refresh()
    func didSelectSort(option: StatsSortOption)
    func didSelectUser(id: String)
}

enum StatsSortOption {
    case rating
    case name
}

final class StatsPresenterImpl: StatsPresenter {

    weak var view: StatsView?

    private let usersService: UsersService
    private let router: StatsRouting

    init(usersService: UsersService, router: StatsRouting) {
        self.usersService = usersService
        self.router = router
    }

    func didSelectUser(id: String) {
        router.showProfile(userId: id)
    }
    
    private var users: [User] = []
    private var sortOption: StatsSortOption = .rating
    
    private var isLoading = false
    private let pageSize = 25
    
    func viewDidLoad() {
        view?.display(items: [])
    }
    
    func refresh() {
        users = []
        loadAllPages()
    }
    
    func didSelectSort(option: StatsSortOption) {
        sortOption = option
        applySortAndDisplay()
    }
    
    private func loadAllPages() {
        guard !isLoading else { return }
        isLoading = true
        view?.displayLoading(true)
        
        func loadPage(_ page: Int) {
            usersService.loadUsers(page: page) { [weak self] result in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let usersPage):
                        self.users.append(contentsOf: usersPage)
                        if usersPage.count < self.pageSize-1 {
                            self.isLoading = false
                            self.view?.displayLoading(false)
                            self.applySortAndDisplay()
                        } else {
                            loadPage(page + 1)
                        }
                    case .failure:
                        self.isLoading = false
                        self.view?.displayLoading(false)
                        let primary = ErrorAction(
                            title: NSLocalizedString("Error.repeat", comment: ""),
                            style: .default
                        ) { [weak self] in
                            self?.loadAllPages()
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
                    }
                }
            }
        }
        loadPage(0)
    }
    
    private func applySortAndDisplay() {
        let ratingsById = ratings(users)
        let sortedUsers = sorted(users)
        let models = sortedUsers.map { user in
            StatsItemCellModel(
                id: user.id,
                name: user.name,
                avatar: user.avatar,
                nfts: user.nfts,
                rating: ratingsById[user.id] ?? 0
            )
        }
        view?.display(items: models)
    }
    
    private func sorted(_ users: [User]) -> [User] {
        switch sortOption {
        case .rating:
            return sortByRating(users)
        case .name:
            return users.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }
    
    private func ratings(_ users: [User]) -> [String: Int] {
        let sortedByRating = sortByRating(users)
        var ratingById: [String: Int] = [:]
        for (index, user) in sortedByRating.enumerated() {
            ratingById[user.id] = index + 1
        }
        return ratingById
    }
    
    private func sortByRating(_ users: [User]) -> [User] {
        users.sorted { lhs, rhs in
            let leftCount = lhs.nfts.count
            let rightCount = rhs.nfts.count
            if leftCount == rightCount {
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
            return leftCount > rightCount
        }
    }
}

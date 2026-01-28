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
    func loadNextPage()
}

enum StatsSortOption {
    case rating
    case name
}

final class StatsPresenterImpl: StatsPresenter {
    
    weak var view: StatsView?
    
    private let usersService: UsersService
    private var users: [User] = []
    private var sortOption: StatsSortOption = .rating
    
    private var page = 0
    private var isLoading = false
    private var hasMore = true
    private let pageSize = 20
    
    init(usersService: UsersService) {
        self.usersService = usersService
    }
    
    func viewDidLoad() {
        view?.display(items: [])
    }
    
    func refresh() {
        page = 0
        hasMore = true
        users = []
        loadAllPages()
    }
    
    func loadNextPage() {
        loadUsers(page: page, showLoading: false)
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

                        if usersPage.count < self.pageSize {
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
                            self?.loadUsers(page: self?.page ?? 0, showLoading: true)
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

        loadPage(page)
    }
    
    private func loadUsers(page: Int, showLoading: Bool) {
        guard !isLoading, hasMore else { return }
        isLoading = true
        if showLoading { view?.displayLoading(true) }

        usersService.loadUsers(page: page) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                assert(Thread.isMainThread)
                if showLoading { self.view?.displayLoading(false) }
                self.isLoading = false

                switch result {
                case .success(let usersPage):
                    if page == 0 {
                        self.users = usersPage
                    } else {
                        self.users.append(contentsOf: usersPage)
                    }

                    if usersPage.count < self.pageSize {
                        self.hasMore = false
                    } else {
                        self.page += 1
                    }

                    self.applySortAndDisplay()

                case .failure:
                    let primary = ErrorAction(
                        title: NSLocalizedString("Error.repeat", comment: ""),
                        style: .default
                    ) { [weak self] in
                        self?.loadUsers(page: self?.page ?? 0, showLoading: true)
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

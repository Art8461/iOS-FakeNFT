//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 24.01.2026.
//

import Foundation

protocol PaymentView: AnyObject, ErrorView {
    func display(currencies: [CurrencyCellModel])
    func displayLoading(_ isLoading: Bool)
    func setPayEnabled(_ isEnabled: Bool)
    func openUserAgreement(url: URL)
    func showPaymentSuccess()
    func returnToBasket()
}

protocol PaymentPresenter {
    func viewDidLoad()
    func didSelectCurrency(at index: Int)
    func didTapPay()
    func didTapUserAgreement()
    func didTapReturnToBasket()
}

final class PaymentPresenterImpl: PaymentPresenter {

    weak var view: PaymentView?

    private let orderId: String
    
    private let currencyService: CurrenciesService
    private let paymentService: PaymentService
    private let basketService: BasketService

    private var cellModels: [CurrencyCellModel] = []
    private var selectedCurrencyId: String?

    init(currencyService: CurrenciesService, paymentService: PaymentService, basketService: BasketService, orderId: String) {
        self.currencyService = currencyService
        self.paymentService = paymentService
        self.basketService = basketService
        self.orderId = orderId
    }

    func viewDidLoad() {
        view?.setPayEnabled(false)
        loadCurrencies()
    }

    func didSelectCurrency(at index: Int) {
        guard cellModels.indices.contains(index) else { return }
        selectedCurrencyId = cellModels[index].id
        view?.setPayEnabled(true)
    }

    func didTapPay() {
        guard let currencyId = selectedCurrencyId else { return }
        view?.displayLoading(true)

        paymentService.payOrder(currencyId: currencyId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.view?.displayLoading(false)
                switch result {
                case .success(let response):
                    if response.success {
                        self.view?.showPaymentSuccess()
                    } else {
                        let model = ErrorModel(
                            message: NSLocalizedString("Error.network", comment: ""),
                            actionText: NSLocalizedString("Error.repeat", comment: "")
                        ) { [weak self] in
                            self?.didTapPay()
                        }
                        self.view?.showError(model)
                    }
                case .failure:
                    let model = ErrorModel(
                        message: NSLocalizedString("Error.network", comment: ""),
                        actionText: NSLocalizedString("Error.repeat", comment: "")
                    ) { [weak self] in
                        self?.didTapPay()
                    }
                    self.view?.showError(model)
                }
            }
        }
    }

    func didTapReturnToBasket() {
        view?.displayLoading(true)
        basketService.completeOrder(orderId: orderId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.view?.displayLoading(false)
                // игнорируем любую ошибку
                self.view?.returnToBasket()
            }
        }
    }
    
    func didTapUserAgreement() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse") else { return }
        view?.openUserAgreement(url: url)
    }

    private func loadCurrencies() {
        view?.displayLoading(true)
        currencyService.loadCurrencies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.view?.displayLoading(false)
                switch result {
                case .success(let currencies):
                    self.cellModels = currencies.map {
                        CurrencyCellModel(
                            id: $0.id,
                            title: $0.title,
                            name: $0.name,
                            image: $0.image
                        )
                    }
                    self.view?.display(currencies: self.cellModels)
                case .failure:
                    let model = ErrorModel(
                        message: NSLocalizedString("Error.network", comment: ""),
                        actionText: NSLocalizedString("Error.repeat", comment: "")
                    ) { [weak self] in
                        self?.loadCurrencies()
                    }
                    self.view?.showError(model)
                }
            }
        }
    }
}

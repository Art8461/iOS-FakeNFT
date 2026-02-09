//
//  WebViewPresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 28.01.2026.
//

import Foundation

protocol WebViewPresenterProtocol: AnyObject {
    func didTapBack()
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewProtocol?

    func didTapBack() {
        view?.closeWebView()
    }
}

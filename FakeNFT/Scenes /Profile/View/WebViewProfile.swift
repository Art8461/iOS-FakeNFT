//
//  WebViewProfile.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 28.01.2026.
//

import UIKit
import WebKit

protocol WebViewViewProtocol: AnyObject {
    func closeWebView()
    func showErrorRetry(_ retryAction: @escaping () -> Void)
}

final class WebViewProfile: UIViewController {

    private let presenter: WebViewPresenterProtocol
    private let url: URL
    private var webView: WKWebView!

    // MARK: - Init
    init(url: URL, presenter: WebViewPresenterProtocol) {
        self.url = url
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        setupNavigationBar()
        loadPage()
    }

    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = .backButton(
            target: self,
            action: #selector(tapBackButton)
        )
    }

    private func loadPage() {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // MARK: - Actions
    @objc private func tapBackButton() {
        presenter.didTapBack()
    }

    private func showRetryAlert() {
        DispatchQueue.main.async { [weak self] in
            self?.showErrorRetry { [weak self] in
                self?.loadPage()
            }
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebViewProfile: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showRetryAlert()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showRetryAlert()
    }
}

// MARK: - WebViewViewProtocol
extension WebViewProfile: WebViewViewProtocol {

    func closeWebView() {
        navigationController?.popViewController(animated: true)
    }

    func showErrorRetry(_ retryAction: @escaping () -> Void) {
        presentErrorRetry(retryAction)
    }
}


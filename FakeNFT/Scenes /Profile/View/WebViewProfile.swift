//
//  WebViewProfile.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 28.01.2026.
//

import UIKit
import WebKit

final class WebViewProfile: UIViewController {
    
    private let presenter: ProfileEditPresenterProtocol
    
    private let url: URL
    private var webView: WKWebView!
    
    init(url: URL,presenter: ProfileEditPresenterProtocol) {
        self.url = url
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = .backButton(
            target: self,
            action: #selector(tapBackButton)
        )
    }
    
    
    @objc private func tapBackButton() {
        presenter.didTapWebBack()
    }
}

extension WebViewProfile: ProfileEditViewProtocol {
    func closeWebView() {
        navigationController?.popViewController(animated: true)
    }
    
    func showProfile(model: ProfileEditModel) {}
    func showExitAlert() {}
    func closeSave() {}
    func showAvatarAlert() {}
}

//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 25.01.2026.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    private let url: URL
    private lazy var webView = WKWebView()

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
    }
}

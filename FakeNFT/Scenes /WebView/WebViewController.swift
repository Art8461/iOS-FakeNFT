import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    private let webView = WKWebView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        
        guard let url = URL(string: "https://practicum.yandex.ru/catalog/programming/?from=main_programming_card&searchText=ios") else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}

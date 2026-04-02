import UIKit
import WebKit

class ViewController: UIViewController {

    var webView: WKWebView?
    private let bridge = GameBridge()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    private func setupWebView() {
        let contentController = WKUserContentController()
        bridge.viewController = self
        contentController.add(bridge, name: "stripeCheckout")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let wv = WKWebView(frame: view.bounds, configuration: config)
        wv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wv.scrollView.isScrollEnabled = false
        wv.scrollView.bounces = false
        wv.isOpaque = false
        wv.backgroundColor = UIColor(red: 0.04, green: 0.1, blue: 0.03, alpha: 1)
        wv.navigationDelegate = self

        view.addSubview(wv)
        self.webView = wv

        // Register webView with StoreKit so it can call grantGems() on purchase
        StoreKitHandler.shared.setWebView(wv)

        loadGame()
    }

    private func loadGame() {
        if let url = Bundle.main.url(forResource: "game", withExtension: "html", subdirectory: "Resources") {
            webView?.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        } else if let url = Bundle.main.url(forResource: "game", withExtension: "html") {
            webView?.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
           url.isFileURL || url.absoluteString == "about:blank" {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
    }
}

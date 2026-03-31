import UIKit
import SafariServices

class StripeHandler: NSObject {

    static let shared = StripeHandler()

    // ─── REPLACE THESE WITH YOUR LIVE STRIPE PAYMENT LINKS ───────────────────
    // In Stripe Dashboard, set the "After payment" redirect URL for each link:
    //   50  gems → callemiguel://stripe-success?gems=50
    //   120 gems → callemiguel://stripe-success?gems=120
    //   300 gems → callemiguel://stripe-success?gems=300
    // ─────────────────────────────────────────────────────────────────────────
    private let paymentLinks: [String: String] = [
        "price_SMALL":  "https://buy.stripe.com/REPLACE_50_GEMS",
        "price_MEDIUM": "https://buy.stripe.com/REPLACE_120_GEMS",
        "price_LARGE":  "https://buy.stripe.com/REPLACE_300_GEMS",
    ]

    private weak var presentingViewController: UIViewController?
    private var pendingGems: Int = 0

    private override init() {}

    /// Opens Stripe Payment Link in SFSafariViewController
    func openCheckout(priceId: String, gems: Int, from viewController: UIViewController?) {
        guard let urlString = paymentLinks[priceId],
              urlString.hasPrefix("https://buy.stripe.com/"),
              !urlString.contains("REPLACE"),
              let url = URL(string: urlString)
        else {
            viewController?.webView?.evaluateJavaScript(
                "document.getElementById('shop-status').textContent='Stripe not configured yet.';"
            )
            return
        }

        pendingGems = gems
        presentingViewController = viewController

        let safari = SFSafariViewController(url: url)
        safari.modalPresentationStyle = .pageSheet
        viewController?.present(safari, animated: true)
    }

    /// Called when app receives callemiguel://stripe-success?gems=N deep link
    @discardableResult
    func handleDeepLink(_ url: URL) -> Bool {
        guard url.scheme == "callemiguel",
              url.host == "stripe-success"
        else { return false }

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let gemsParam = components?.queryItems?.first(where: { $0.name == "gems" })?.value
        let gems = Int(gemsParam ?? "") ?? pendingGems

        presentingViewController?.dismiss(animated: true) { [weak self] in
            self?.grantGems(gems)
        }

        pendingGems = 0
        return true
    }

    /// Calls grantGems(N) in the WKWebView to credit gems and persist
    private func grantGems(_ gems: Int) {
        guard gems > 0 else { return }
        (presentingViewController as? ViewController)?.webView?
            .evaluateJavaScript("grantGems(\(gems));")
    }
}

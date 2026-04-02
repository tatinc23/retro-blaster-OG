import WebKit

/// Receives messages posted from JavaScript via:
///   window.webkit.messageHandlers.stripeCheckout.postMessage({priceId: "...", gems: N})
/// The handler name "stripeCheckout" is kept for JS compatibility.
class GameBridge: NSObject, WKScriptMessageHandler {

    weak var viewController: ViewController?

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard message.name == "stripeCheckout",
              let body = message.body as? [String: Any],
              let priceId = body["priceId"] as? String
        else { return }

        // Route to Apple IAP
        StoreKitHandler.shared.purchase(priceId: priceId)
    }
}

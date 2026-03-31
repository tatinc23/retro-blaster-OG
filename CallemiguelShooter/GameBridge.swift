import WebKit

/// Receives messages posted from JavaScript via:
///   window.webkit.messageHandlers.stripeCheckout.postMessage({priceId: "...", gems: N})
class GameBridge: NSObject, WKScriptMessageHandler {

    weak var viewController: ViewController?

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard message.name == "stripeCheckout",
              let body = message.body as? [String: Any],
              let priceId = body["priceId"] as? String,
              let gems = body["gems"] as? Int
        else { return }

        StripeHandler.shared.openCheckout(priceId: priceId, gems: gems, from: viewController)
    }
}

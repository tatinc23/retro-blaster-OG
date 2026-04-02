import StoreKit
import WebKit

/// Handles Apple In-App Purchase for gem packs.
/// Product IDs must match exactly what you create in App Store Connect.
/// Format: com.tatinc.retroblaster.gems50 / gems120 / gems300
class StoreKitHandler: NSObject {

    static let shared = StoreKitHandler()

    // Map the same priceId keys the JS uses → App Store Connect product IDs
    private let productMap: [String: String] = [
        "price_SMALL":  "com.tatinc.retroblaster.gems50",
        "price_MEDIUM": "com.tatinc.retroblaster.gems120",
        "price_LARGE":  "com.tatinc.retroblaster.gems300",
    ]

    // Reverse map: productId → gems to grant
    private let gemsForProduct: [String: Int] = [
        "com.tatinc.retroblaster.gems50":  50,
        "com.tatinc.retroblaster.gems120": 120,
        "com.tatinc.retroblaster.gems300": 300,
    ]

    private weak var webView: WKWebView?
    private var products: [String: SKProduct] = [:]

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        fetchProducts()
    }

    // MARK: – Public

    func setWebView(_ wv: WKWebView) {
        webView = wv
    }

    func purchase(priceId: String) {
        guard SKPaymentQueue.canMakePayments() else {
            postStatus("Purchases are disabled on this device.")
            return
        }
        guard let productId = productMap[priceId] else {
            postStatus("Unknown product.")
            return
        }
        if let product = products[productId] {
            SKPaymentQueue.default().add(SKPayment(product: product))
        } else {
            // Products not yet fetched — fetch then buy
            fetchProducts { [weak self] in
                if let product = self?.products[productId] {
                    SKPaymentQueue.default().add(SKPayment(product: product))
                } else {
                    self?.postStatus("Product unavailable. Check App Store Connect.")
                }
            }
        }
    }

    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    // MARK: – Private

    private var fetchCompletion: (() -> Void)?

    private func fetchProducts(completion: (() -> Void)? = nil) {
        fetchCompletion = completion
        let ids = Set(productMap.values)
        let request = SKProductsRequest(productIdentifiers: ids)
        request.delegate = self
        request.start()
    }

    private func postStatus(_ msg: String) {
        let escaped = msg.replacingOccurrences(of: "'", with: "\\'")
        webView?.evaluateJavaScript(
            "document.getElementById('shop-status').textContent='\(escaped)';"
        )
    }

    private func grantGems(_ gems: Int) {
        webView?.evaluateJavaScript("grantGems(\(gems));")
    }
}

// MARK: – SKProductsRequestDelegate

extension StoreKitHandler: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            products[product.productIdentifier] = product
        }
        DispatchQueue.main.async { [weak self] in
            self?.fetchCompletion?()
            self?.fetchCompletion = nil
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.postStatus("Could not load products.")
            self?.fetchCompletion = nil
        }
    }
}

// MARK: – SKPaymentTransactionObserver

extension StoreKitHandler: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                let productId = transaction.payment.productIdentifier
                if let gems = gemsForProduct[productId] {
                    DispatchQueue.main.async { [weak self] in
                        self?.grantGems(gems)
                        self?.postStatus("Purchase complete! +\(gems) gems")
                    }
                }
                SKPaymentQueue.default().finishTransaction(transaction)

            case .failed:
                let msg = (transaction.error as? SKError)?.code == .paymentCancelled
                    ? "" : "Purchase failed. Please try again."
                if !msg.isEmpty {
                    DispatchQueue.main.async { [weak self] in self?.postStatus(msg) }
                }
                SKPaymentQueue.default().finishTransaction(transaction)

            case .deferred, .purchasing:
                break

            @unknown default:
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        DispatchQueue.main.async { [weak self] in
            self?.postStatus("Purchases restored.")
        }
    }
}

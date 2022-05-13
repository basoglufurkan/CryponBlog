//
//  StoreManager.swift
//  CryponBlog
//
//  Created by Furkan Başoğlu on 10.04.2022.
//

import Foundation
import StoreKit

typealias RestoreCompletion = (Result<Bool ,Error>) -> Void

class StoreManager: NSObject, ObservableObject , SKProductsRequestDelegate, SKPaymentTransactionObserver {
    let onPurchaseProduct: (SKProduct) -> ()
    var request: SKProductsRequest!
    @Published var myProducts = [SKProduct]()
    @Published var transactionState: SKPaymentTransactionState?
    private var restoreCompletion: RestoreCompletion?
    private var hasRestoredProducts: Bool?
    
    init(onPurchaseProduct: @escaping (SKProduct) -> ()) {
        self.onPurchaseProduct = onPurchaseProduct
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Did receive response")
        
        if !response.products.isEmpty {
            for fetchedProduct in response.products {
                DispatchQueue.main.async {
                    self.myProducts.append(fetchedProduct)
                }
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Invalid identifiers found: \(invalidIdentifier)")
        }
    }
    
    func getProducts(productIDs: [String]) {
        print("Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request did fail: \(error)")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                transactionState = .purchasing
            case .purchased:
                handlePurchase(productID: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                transactionState = .purchased
            case .restored:
                hasRestoredProducts = true
                handlePurchase(productID: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                transactionState = .restored
            case .failed, .deferred:
                print("Payment Queue Error: \(String(describing: transaction.error))")
                queue.finishTransaction(transaction)
                transactionState = .failed
            default:
                queue.finishTransaction(transaction)
            }
        }
    }
    
    private func handlePurchase(productID: String) {
        if let product = myProducts.first(where: { $0.productIdentifier == productID }) {
            onPurchaseProduct(product)
        }
    }
    
    func purchaseProduct(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User can't make payment.")
        }
        
    }
    
    func restorePurchases(completion: @escaping RestoreCompletion) {
        SKPaymentQueue.default().restoreCompletedTransactions()
        hasRestoredProducts = nil
        restoreCompletion = completion
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        restoreCompletion?(.success(hasRestoredProducts == true))
        restoreCompletion = nil
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        restoreCompletion?(.failure(error))
        restoreCompletion = nil
    }
}


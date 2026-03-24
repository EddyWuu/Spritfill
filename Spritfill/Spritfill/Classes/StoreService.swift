//
//  StoreService.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-24.
//

import Foundation
import StoreKit

// Singleton service handling all StoreKit 2 operations:
// product loading, purchasing, transaction verification, and entitlement tracking.
@MainActor
class StoreService: ObservableObject {
    
    static let shared = StoreService()
    
    // MARK: - Published State
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published private(set) var isLoading = false
    
    // Convenience: whether the user has purchased the pro unlock
    var isPro: Bool {
        purchasedProductIDs.contains(StoreProducts.proUnlock)
    }
    
    // MARK: - Private
    
    private var transactionListener: Task<Void, Error>?
    private let cacheKey = "StoreService.purchasedProductIDs"
    
    // MARK: - Init
    
    private init() {
        loadCachedEntitlements()
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    // MARK: - Transaction Listener
    
    func startTransactionListener() {
        transactionListener?.cancel()
        transactionListener = Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self = self else { return }
                if let transaction = try? result.payloadValue {
                    await self.handleVerified(transaction)
                }
            }
        }
    }
    
    // MARK: - Load Products
    
    func loadProducts() async {
        guard !isLoading else { return }
        guard products.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let ids = StoreProducts.allProductIDs
            print("StoreService: Requesting products for IDs: \(ids)")
            let storeProducts = try await Product.products(for: ids)
            print("StoreService: Loaded \(storeProducts.count) products: \(storeProducts.map { $0.id })")
            products = storeProducts
            await refreshEntitlements()
        } catch {
            print("StoreService: Failed to load products: \(error)")
        }
    }
    
    // MARK: - Purchase
    
    @discardableResult
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            if let transaction = try? verification.payloadValue {
                await handleVerified(transaction)
                return true
            }
            return false
        case .userCancelled:
            return false
        case .pending:
            return false
        @unknown default:
            return false
        }
    }
    
    // MARK: - Restore Purchases
    
    func restorePurchases() async {
        try? await AppStore.sync()
        await refreshEntitlements()
    }
    
    // MARK: - Entitlements
    
    func refreshEntitlements() async {
        var entitled = Set<String>()
        for await result in Transaction.currentEntitlements {
            if let transaction = try? result.payloadValue {
                if transaction.revocationDate == nil {
                    entitled.insert(transaction.productID)
                }
            }
        }
        purchasedProductIDs = entitled
        saveCachedEntitlements()
    }
    
    // MARK: - Helpers
    
    private func handleVerified(_ transaction: Transaction) async {
        if transaction.productID == StoreProducts.proUnlock {
            if transaction.revocationDate == nil {
                purchasedProductIDs.insert(transaction.productID)
            } else {
                purchasedProductIDs.remove(transaction.productID)
            }
            saveCachedEntitlements()
        }
        await transaction.finish()
    }
    
    private func saveCachedEntitlements() {
        UserDefaults.standard.set(Array(purchasedProductIDs), forKey: cacheKey)
    }
    
    private func loadCachedEntitlements() {
        if let array = UserDefaults.standard.stringArray(forKey: cacheKey) {
            purchasedProductIDs = Set(array)
        }
    }
    
    func proProduct() -> Product? {
        products.first { $0.id == StoreProducts.proUnlock }
    }
}

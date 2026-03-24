//
//  StoreService.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-24.
//

import Foundation
import StoreKit

// Singleton service handling all StoreKit 2 operations:
// product loading and purchasing for consumable donations.
@MainActor
class StoreService: ObservableObject {
    
    static let shared = StoreService()
    
    // MARK: - Published State
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading = false
    
    // MARK: - Private
    
    private var transactionListener: Task<Void, Error>?
    
    // MARK: - Init
    
    private init() {}
    
    deinit {
        transactionListener?.cancel()
    }
    
    // MARK: - Transaction Listener
    
    // Start listening for transaction updates.
    // Call this once at app launch from SpritfillApp.
    func startTransactionListener() {
        transactionListener?.cancel()
        transactionListener = Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self = self else { return }
                if let transaction = try? result.payloadValue {
                    await transaction.finish()
                }
            }
        }
    }
    
    // MARK: - Load Products
    
    // Fetch products from the App Store (or StoreKit config for testing).
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
            products = storeProducts.sorted { $0.price < $1.price }
        } catch {
            print("StoreService: Failed to load products: \(error)")
        }
    }
    
    // MARK: - Purchase
    
    // Purchase a product. Returns true if purchase succeeded.
    @discardableResult
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            if let transaction = try? verification.payloadValue {
                await transaction.finish()
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
}

//
//  StoreViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-24.
//

import SwiftUI
import StoreKit
import Combine

// ViewModel wrapping StoreService for use in SwiftUI views.
@MainActor
class StoreViewModel: ObservableObject {
    
    private let storeService = StoreService.shared
    private var cancellable: AnyCancellable?
    
    @Published var purchaseError: String?
    @Published var showThankYou = false
    @Published var isPurchasing = false
    
    var products: [Product] { storeService.products }
    var isLoading: Bool { storeService.isLoading }
    
    init() {
        // Forward StoreService changes to trigger SwiftUI updates
        cancellable = storeService.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
    }
    
    // MARK: - Actions
    
    func loadProducts() async {
        await storeService.loadProducts()
    }
    
    func purchase(_ product: Product) async {
        isPurchasing = true
        purchaseError = nil
        defer { isPurchasing = false }
        
        do {
            let success = try await storeService.purchase(product)
            if success {
                showThankYou = true
            }
        } catch {
            purchaseError = error.localizedDescription
        }
    }
}

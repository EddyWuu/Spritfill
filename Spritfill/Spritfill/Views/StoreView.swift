//
//  StoreView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-24.
//

import SwiftUI
import StoreKit

struct StoreView: View {
    
    @StateObject private var viewModel = StoreViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Hero
                    VStack(spacing: 10) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.pink)
                        
                        Text("Support Spritfill")
                            .font(.title3)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Spritfill is made by a solo developer. All features are free — contributions go directly towards keeping the server and database running. Thank you! 💛")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    
                    // MARK: - Loading / Error State
                    if viewModel.products.isEmpty {
                        VStack(spacing: 12) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding(.vertical, 20)
                                Text("Loading...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                    .padding(.top, 12)
                                Text("Unable to load products")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Button("Try Again") {
                                    Task { await viewModel.loadProducts() }
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    }
                    
                    // MARK: - Donation Options
                    if !viewModel.products.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Contributions")
                                .font(.headline)
                            
                            VStack(spacing: 10) {
                                ForEach(viewModel.products) { product in
                                    HStack(spacing: 12) {
                                        Image(systemName: donationIcon(for: product.id))
                                            .font(.title3)
                                            .foregroundColor(donationColor(for: product.id))
                                            .frame(width: 28)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(product.displayName)
                                                .font(.body)
                                                .fontWeight(.medium)
                                        }
                                        
                                        Spacer()
                                        
                                        Button {
                                            Task { await viewModel.purchase(product) }
                                        } label: {
                                            Text(product.displayPrice)
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .tint(.blue)
                                        .disabled(viewModel.isPurchasing)
                                    }
                                    
                                    if product.id != viewModel.products.last?.id {
                                        Divider()
                                    }
                                }
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(14)
                        }
                    }
                    
                    // MARK: - Loading Indicator
                    if viewModel.isPurchasing {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding(.vertical, 8)
                            Spacer()
                        }
                    }
                    
                    // MARK: - Error
                    if let error = viewModel.purchaseError {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    // MARK: - Legal & Contact
                    VStack(spacing: 8) {
                        Link(destination: URL(string: "https://gilded-troodon-368.notion.site/Spritfill-Privacy-Policy-328009ccfd1b8024a242e01b3c37d77b")!) {
                            Text("Privacy Policy")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        
                        Link(destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!) {
                            Text("Terms of Use (EULA)")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        
                        Text("ducksss777@gmail.com")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .navigationTitle("Support")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadProducts()
            }
            .alert("Thank You! 💛", isPresented: $viewModel.showThankYou) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your support means the world! Thank you for helping keep Spritfill running.")
            }
        }
    }
    
    // MARK: - Helpers
    
    private func donationIcon(for productID: String) -> String {
        switch productID {
        case StoreProducts.tipSmall:  return "cup.and.saucer.fill"
        case StoreProducts.tipMedium: return "takeoutbag.and.cup.and.straw.fill"
        case StoreProducts.tipLarge:  return "gift.fill"
        default: return "heart.fill"
        }
    }
    
    private func donationColor(for productID: String) -> Color {
        switch productID {
        case StoreProducts.tipSmall:  return .brown
        case StoreProducts.tipMedium: return .orange
        case StoreProducts.tipLarge:  return .pink
        default: return .pink
        }
    }
}

#Preview {
    StoreView()
}

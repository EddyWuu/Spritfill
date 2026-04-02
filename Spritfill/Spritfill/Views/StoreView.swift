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
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.yellow)
                        
                        Text("Spritfill Pro")
                            .font(.title3)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Unlock the full power of Spritfill with a one-time purchase. No subscriptions.")
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
                    
                    // MARK: - Pro Unlock
                    if let proProduct = viewModel.proProduct {
                        VStack(spacing: 16) {
                            // Purchase row
                            HStack(spacing: 12) {
                                Image(systemName: "star.fill")
                                    .font(.title2)
                                    .foregroundColor(.yellow)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(proProduct.displayName)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                    Text("One-time purchase")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if viewModel.isPro {
                                    Label("Owned", systemImage: "checkmark.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                } else {
                                    Button {
                                        Task { await viewModel.purchase(proProduct) }
                                    } label: {
                                        Text(proProduct.displayPrice)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.blue)
                                    .disabled(viewModel.isPurchasing)
                                }
                            }
                            .padding(16)
                            .background(Color(.systemGray6))
                            .cornerRadius(14)
                            
                            // What's included
                            VStack(alignment: .leading, spacing: 10) {
                                Text("What's Included")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                proFeatureRow(icon: "square.3.layers.3d", color: .purple, text: "Up to 8 layers (free: 2)")
                                proFeatureRow(icon: "square.grid.2x2", color: .blue, text: "128×128 and 256×256 canvas sizes")
                                proFeatureRow(icon: "square.stack.3d.forward.dottedline", color: .green, text: "Gradient tool")
                                proFeatureRow(icon: "checkerboard.rectangle", color: .teal, text: "Dither tool")
                                proFeatureRow(icon: "lasso", color: .cyan, text: "Select & move pixels tool")
                                proFeatureRow(icon: "square.and.arrow.down.on.square", color: .indigo, text: "Import projects as layers")
                                proFeatureRow(icon: "paintpalette.fill", color: .orange, text: "Unlimited extra palette colors (free: 5)")
                                proFeatureRow(icon: "swatchpalette.fill", color: .pink, text: "Unlimited custom palette colors (free: 64)")
                                proFeatureRow(icon: "sparkles", color: .yellow, text: "Exclusive Spritfill 128 palette")
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(14)
                        }
                    }
                    
                    // MARK: - Restore Purchases
                    Button {
                        Task { await viewModel.restorePurchases() }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Restore Purchases")
                        }
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.secondary)
                    
                    // MARK: - Loading
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
                    
                    // MARK: - Legal
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
            .navigationTitle("Spritfill Pro")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadProducts()
            }
            .alert("Welcome to Pro! ⭐", isPresented: $viewModel.showThankYou) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You've unlocked all Spritfill Pro features. Enjoy!")
            }
        }
    }
    
    // MARK: - Helpers
    
    @ViewBuilder
    private func proFeatureRow(icon: String, color: Color, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(color)
                .frame(width: 22)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    StoreView()
}

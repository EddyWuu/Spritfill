//
//  SubmitArtView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-18.
//

import SwiftUI

struct SubmitArtView: View {
    
    @ObservedObject var viewModel: CanvasViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var artistName: String = ""
    @State private var agreeToTerms: Bool = false
    @State private var agreeToPublic: Bool = false
    @State private var agreeToLicense: Bool = false
    @State private var showSuccessAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    
    private var dailyLimitReached: Bool {
        FirebaseSubmissionService.shared.hasReachedDailyLimit
    }
    
    private var remainingSubmissions: Int {
        FirebaseSubmissionService.shared.remainingSubmissions
    }
    
    private var canSubmit: Bool {
        !artistName.trimmingCharacters(in: .whitespaces).isEmpty
        && agreeToTerms
        && agreeToPublic
        && agreeToLicense
        && !viewModel.isSubmitting
        && !dailyLimitReached
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Daily limit warning
                    if dailyLimitReached {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Daily Limit Reached")
                                    .font(.subheadline.weight(.semibold))
                                Text("You've submitted \(FirebaseSubmissionService.maxDailySubmissions) artworks today. Please try again tomorrow.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                    } else {
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.secondary)
                            Text("\(remainingSubmissions) submission\(remainingSubmissions == 1 ? "" : "s") remaining today")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // MARK: - What is this?
                    infoSection
                    
                    Divider()
                    
                    // MARK: - Artist name
                    artistNameSection
                    
                    Divider()
                    
                    // MARK: - Agreements
                    agreementsSection
                    
                    Divider()
                    
                    // MARK: - Privacy disclosure
                    privacySection
                    
                    // MARK: - Submit button
                    submitButton
                        .padding(.top, 8)
                }
                .padding()
            }
            .navigationTitle("Submit Artwork")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .alert("Submitted!", isPresented: $showSuccessAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("Your artwork has been submitted for review. If approved, it will be featured in the community catalog. Thank you!")
        }
        .alert("Submission Failed", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.submissionError ?? "An unknown error occurred.")
        }
    }
    
    // MARK: - Info Section
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("How It Works", systemImage: "star.fill")
                .font(.headline)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 8) {
                bulletPoint("Submit your finished pixel art for review by the Spritfill team.")
                bulletPoint("If approved, your artwork will be featured in the community catalog for all users to see, download, and recreate.")
                bulletPoint("Your artist name will be displayed alongside your artwork to give you credit.")
                bulletPoint("This is a voluntary donation of your artwork — there is no compensation or profile system.")
                bulletPoint("Other users may download and use your artwork freely within Spritfill.")
            }
        }
    }
    
    // MARK: - Artist Name
    
    private var artistNameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Artist Name", systemImage: "person.fill")
                .font(.headline)
            
            Text("This name will be displayed under your artwork if featured. It does not create an account or profile.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            TextField("Enter your name or alias", text: $artistName)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
        }
    }
    
    // MARK: - Agreements
    
    private var agreementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Agreements", systemImage: "checkmark.shield.fill")
                .font(.headline)
            
            Toggle(isOn: $agreeToTerms) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("I agree to submit my artwork for review")
                        .font(.subheadline)
                    Text("I understand this is a voluntary contribution. My artwork may be featured in the Spritfill community catalog for all users to view, download, and recreate. I will not receive compensation. I confirm this is my original work and does not contain copyrighted, offensive, or inappropriate content.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .toggleStyle(CheckToggleStyle())
            
            Toggle(isOn: $agreeToPublic) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("I agree to make my artwork publicly available")
                        .font(.subheadline)
                    Text("Once approved, my artwork and the artist name I provide will be visible to all Spritfill users. Other users will be able to download, save, and recreate my artwork. I can request removal at any time by contacting ducksss777@gmail.com.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .toggleStyle(CheckToggleStyle())
            
            Toggle(isOn: $agreeToLicense) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("I grant a license for my artwork to be used freely")
                        .font(.subheadline)
                    Text("By submitting, I grant Spritfill and its users a perpetual, royalty-free, non-exclusive license to display, download, and recreate my artwork within the app. I waive any claims against the developer for how other users may use my submitted artwork. I understand this is voluntary and I retain ownership of my original work.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .toggleStyle(CheckToggleStyle())
        }
    }
    
    // MARK: - Privacy Section
    
    private var privacySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Privacy & Data", systemImage: "lock.shield.fill")
                .font(.headline)
                .foregroundColor(.green)
            
            VStack(alignment: .leading, spacing: 6) {
                privacyRow(icon: "person.crop.circle.badge.minus", text: "No account is created. No login is required.")
                privacyRow(icon: "envelope.badge.shield.half.filled", text: "No email, phone number, or personal information is collected.")
                privacyRow(icon: "externaldrive.badge.icloud", text: "Only your artwork image, pixel data, and the artist name you provide are uploaded.")
                privacyRow(icon: "server.rack", text: "Submitted data is stored securely on Firebase (Google Cloud) for review purposes only.")
                privacyRow(icon: "trash.circle", text: "You may request deletion of your submission at any time by contacting me at ducksss777@gmail.com.")
                privacyRow(icon: "dollarsign.circle", text: "Your data will never be sold to third parties.")
            }
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Submit Button
    
    private var submitButton: some View {
        Button {
            submitArtwork()
        } label: {
            HStack {
                if viewModel.isSubmitting {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "paperplane.fill")
                }
                Text(viewModel.isSubmitting ? "Submitting..." : "Submit for Review")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(canSubmit ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(14)
        }
        .disabled(!canSubmit)
    }
    
    // MARK: - Helpers
    
    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundColor(.secondary)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private func privacyRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.green)
                .frame(width: 20)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Submit Action
    
    private func submitArtwork() {
        guard canSubmit else { return }
        
        viewModel.submitArtwork(artistName: artistName) { success in
            if success {
                showSuccessAlert = true
            } else {
                showErrorAlert = true
            }
        }
    }
}

// MARK: - Checkbox Toggle Style

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundColor(configuration.isOn ? .blue : .secondary)
                
                configuration.label
            }
        }
        .buttonStyle(.plain)
    }
}

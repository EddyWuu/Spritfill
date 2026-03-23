//
//  CommunityInfoSheetView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-20.
//

import SwiftUI

struct CommunityInfoSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Hero
                    VStack(spacing: 10) {
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.yellow)
                        
                        Text("Want Your Art Showcased Here?")
                            .font(.title3)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Submit your pixel art for a chance to be featured in the community section for everyone to see and recreate!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    
                    // MARK: - Steps
                    VStack(alignment: .leading, spacing: 16) {
                        Text("How to Submit")
                            .font(.headline)
                        
                        stepRow(number: 1,
                                icon: "paintbrush.pointed",
                                title: "Create Your Sprite",
                                description: "Draw your pixel art in the Canvas tab. Make it something you're proud of!")
                        
                        stepRow(number: 2,
                                icon: "checkmark.seal",
                                title: "Mark as Finished",
                                description: "When you're done, tap the ✓ button in the top bar to mark your project as finished.")
                        
                        stepRow(number: 3,
                                icon: "paperplane",
                                title: "Submit for Review",
                                description: "Open your finished project from the Finished tab and tap the \"Submit\" button. Enter an artist name (a pseudonym works!) and send it off.")
                        
                        stepRow(number: 4,
                                icon: "eyes",
                                title: "Review Process",
                                description: "Your submission is manually reviewed. If approved, it'll appear in the Community section for all users to enjoy and recreate!")
                    }
                    .padding(16)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    
                    // MARK: - Guidelines
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Guidelines")
                            .font(.headline)
                        
                        guidelineRow(icon: "hand.thumbsup", text: "Original artwork only — no copies of existing art")
                        guidelineRow(icon: "face.smiling", text: "Keep it friendly and appropriate for all ages")
                        guidelineRow(icon: "sparkles", text: "Put effort in — low-effort scribbles will be declined")
                        guidelineRow(icon: "person.crop.circle", text: "Artist names can be pseudonyms — no real name required")
                    }
                    .padding(16)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    
                    // MARK: - Note
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                            .font(.body)
                        Text("Not every submission will be accepted, and that's okay! Keep creating and try again.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(14)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Community Submissions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    // MARK: - Step Row
    
    private func stepRow(number: Int, icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 32, height: 32)
                Text("\(number)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    // MARK: - Guideline Row
    
    private func guidelineRow(icon: String, text: String) -> some View {
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
}

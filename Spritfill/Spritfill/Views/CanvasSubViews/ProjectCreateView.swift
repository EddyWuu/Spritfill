//
//  ProjectCreateView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

struct ProjectCreateView: View {

    @ObservedObject var viewModel: CanvasViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        let projectManager = ProjectManagerViewModel()
                        projectManager.save(viewModel)
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }

                    Spacer()

                    HStack {
                        Button(action: {
                            // Save
                        }) {
                            Image(systemName: "square.and.arrow.down")
                        }
                        Button(action: {
                            // Share
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
                .padding()
                .frame(height: geo.size.height * 0.08)
                .background(Color.gray.opacity(0.3))

                ProjectCanvasView(viewModel: viewModel)
                    .frame(height: geo.size.height * 0.54)
                    .clipped()

                HStack {
                    Spacer()
                    Text("Tools go here").foregroundColor(.gray)
                    Spacer()
                }
                .frame(height: geo.size.height * 0.38)
                .background(Color.gray.opacity(0.2))
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}

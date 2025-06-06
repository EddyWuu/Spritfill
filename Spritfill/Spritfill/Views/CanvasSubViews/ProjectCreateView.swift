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
                        
                        // save automatically when pressing back
                        let projectManager = ProjectManagerViewModel()
                        projectManager.save(viewModel)

                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            // Saving, might not be necessary depending on how i will build share
                        }) {
                            Image(systemName: "square.and.arrow.down")
                        }
                        Button(action: {
                            // Sharing
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
                .frame(height: geo.size.height * 0.01)
                .padding()
                .background(Color.gray.opacity(0.3))

                Divider()

                ProjectCanvasView(viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                Divider()

                HStack {
                    Spacer()
                    Text("Tools go here").foregroundColor(.gray)
                    Spacer()
                }
                .frame(height: geo.size.height * 0.45)
                .background(Color.gray.opacity(0.2))
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}

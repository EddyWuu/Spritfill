//
//  ProjectCreateView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

struct ProjectCreateView: View {
    @ObservedObject var viewModel: CanvasViewModel

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                
                HStack {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.down")
                        }
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.3))

                Divider()

                ProjectCanvasView(viewModel: viewModel)

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

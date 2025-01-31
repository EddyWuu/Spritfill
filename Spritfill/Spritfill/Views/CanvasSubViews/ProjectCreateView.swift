//
//  ProjectCreateView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

struct ProjectCreateView: View {
    
    @ObservedObject var viewModel: ProjectViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    
    @State private var zoomScale: CGFloat = 1.0  // track zoom level
    @State private var lastScale: CGFloat = 1.0  // track the last pinch scale
    
    @State private var pinchCenter: CGPoint = .zero
    
    var body: some View {
        
        VStack {
            
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Back")
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                }
                Spacer()
            }
            .padding(.top)
            
            Spacer()
            
            GeometryReader { geometry in
                
                 ProjectCanvasView(viewModel: viewModel, zoomScale: $zoomScale)
                     .scaleEffect(zoomScale, anchor: UnitPoint(
                         x: pinchCenter.x / geometry.size.width,
                         y: pinchCenter.y / geometry.size.height
                     ))
                     .gesture(
                         MagnificationGesture()
                             .onChanged { scale in
                                 zoomScale = max(0.5, min(lastScale * scale, 5.0))
                             }
                             .onEnded { _ in
                                 lastScale = zoomScale
                             }
                     )
                     .simultaneousGesture(
                         DragGesture()
                             .onChanged { value in
                                 pinchCenter = value.location
                             }
                     )
             }
             .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}

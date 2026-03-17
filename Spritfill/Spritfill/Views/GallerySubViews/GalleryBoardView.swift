//
//  GalleryBoardView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import SwiftUI

struct GalleryBoardView: View {
    
    @ObservedObject var viewModel: GalleryViewModel
    
    @State private var panOffset: CGSize = .zero
    @State private var panStart: CGSize = .zero
    @State private var pinchScale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geo in
            let combinedScale = viewModel.zoomScale * pinchScale
            
            ZStack {
                // Board background
                boardBackground
                
                // Sprite items
                ForEach(viewModel.visibleItems) { item in
                    GalleryBoardItemView(viewModel: viewModel, item: item)
                }
            }
            .frame(width: viewModel.boardSize, height: viewModel.boardSize)
            .scaleEffect(combinedScale)
            .offset(
                x: panOffset.width + (viewModel.boardOffset.width - viewModel.boardSize / 2 + geo.size.width / 2),
                y: panOffset.height + (viewModel.boardOffset.height - viewModel.boardSize / 2 + geo.size.height / 2)
            )
            .gesture(panGesture(geo: geo))
            .simultaneousGesture(pinchGesture)
            .clipped()
        }
    }
    
    // MARK: - Board background
    
    private var boardBackground: some View {
        ZStack {
            // Subtle dot grid pattern
            Canvas { context, size in
                let spacing: CGFloat = 40
                let dotSize: CGFloat = 2
                let rows = Int(size.height / spacing)
                let cols = Int(size.width / spacing)
                
                for row in 0...rows {
                    for col in 0...cols {
                        let rect = CGRect(
                            x: CGFloat(col) * spacing - dotSize / 2,
                            y: CGFloat(row) * spacing - dotSize / 2,
                            width: dotSize,
                            height: dotSize
                        )
                        context.fill(
                            Path(ellipseIn: rect),
                            with: .color(Color.gray.opacity(0.15))
                        )
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Pan gesture
    
    private func panGesture(geo: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                if viewModel.canPan {
                    panOffset = CGSize(
                        width: panStart.width + value.translation.width,
                        height: panStart.height + value.translation.height
                    )
                }
            }
            .onEnded { _ in
                if viewModel.canPan {
                    panStart = panOffset
                }
            }
    }
    
    // MARK: - Pinch to zoom
    
    private var pinchGesture: some Gesture {
        MagnificationGesture()
            .onChanged { scale in
                pinchScale = scale
            }
            .onEnded { scale in
                viewModel.applyPinchEnd(scale: scale)
                pinchScale = 1.0
            }
    }
}

//
//  GalleryBoardView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import SwiftUI
import UIKit

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
                
                // Sprite items (selected one drawn last = on top)
                ForEach(viewModel.sortedVisibleItems) { item in
                    GalleryBoardItemView(viewModel: viewModel, item: item)
                }
            }
            .frame(width: viewModel.boardSize, height: viewModel.boardSize)
            .scaleEffect(combinedScale)
            .offset(
                x: panOffset.width + (viewModel.boardOffset.width - viewModel.boardSize / 2 + geo.size.width / 2),
                y: panOffset.height + (viewModel.boardOffset.height - viewModel.boardSize / 2 + geo.size.height / 2)
            )
            .overlay(
                GalleryGestureView(
                    isEditMode: viewModel.isEditMode,
                    onPan: { delta in
                        panOffset = CGSize(
                            width: panStart.width + delta.width,
                            height: panStart.height + delta.height
                        )
                    },
                    onPanEnd: {
                        panStart = panOffset
                    },
                    onPinch: { scale in
                        pinchScale = scale
                    },
                    onPinchEnd: { scale in
                        viewModel.applyPinchEnd(scale: scale)
                        pinchScale = 1.0
                    }
                )
            )
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
}

// MARK: - UIKit Gesture View for smooth panning/pinching

struct GalleryGestureView: UIViewRepresentable {
    var isEditMode: Bool
    var onPan: (CGSize) -> Void
    var onPanEnd: () -> Void
    var onPinch: (CGFloat) -> Void
    var onPinchEnd: (CGFloat) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPan: onPan, onPanEnd: onPanEnd, onPinch: onPinch, onPinchEnd: onPinchEnd)
    }
    
    func makeUIView(context: Context) -> GalleryPassthroughView {
        let view = GalleryPassthroughView()
        view.backgroundColor = .clear
        view.coordinator = context.coordinator
        
        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 2
        pan.cancelsTouchesInView = false
        pan.delaysTouchesBegan = false
        pan.delaysTouchesEnded = false
        pan.delegate = context.coordinator
        context.coordinator.panGesture = pan
        view.addGestureRecognizer(pan)
        
        let pinch = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(_:)))
        pinch.cancelsTouchesInView = false
        pinch.delaysTouchesBegan = false
        pinch.delaysTouchesEnded = false
        pinch.delegate = context.coordinator
        view.addGestureRecognizer(pinch)
        
        return view
    }
    
    func updateUIView(_ uiView: GalleryPassthroughView, context: Context) {
        context.coordinator.onPan = onPan
        context.coordinator.onPanEnd = onPanEnd
        context.coordinator.onPinch = onPinch
        context.coordinator.onPinchEnd = onPinchEnd
        context.coordinator.isEditMode = isEditMode
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onPan: (CGSize) -> Void
        var onPanEnd: () -> Void
        var onPinch: (CGFloat) -> Void
        var onPinchEnd: (CGFloat) -> Void
        var isEditMode: Bool = false
        weak var panGesture: UIPanGestureRecognizer?
        
        init(onPan: @escaping (CGSize) -> Void, onPanEnd: @escaping () -> Void,
             onPinch: @escaping (CGFloat) -> Void, onPinchEnd: @escaping (CGFloat) -> Void) {
            self.onPan = onPan
            self.onPanEnd = onPanEnd
            self.onPinch = onPinch
            self.onPinchEnd = onPinchEnd
        }
        
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: gesture.view)
            switch gesture.state {
            case .changed:
                onPan(CGSize(width: translation.x, height: translation.y))
            case .ended, .cancelled:
                onPan(CGSize(width: translation.x, height: translation.y))
                onPanEnd()
                gesture.setTranslation(.zero, in: gesture.view)
            default:
                break
            }
        }
        
        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            switch gesture.state {
            case .changed:
                onPinch(gesture.scale)
            case .ended, .cancelled:
                onPinchEnd(gesture.scale)
                gesture.scale = 1.0
            default:
                break
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}

/// Custom UIView that passes through ALL touches in edit mode,
/// so SwiftUI item drag/resize/tap gestures work underneath.
/// In view mode, it intercepts touches for smooth UIKit panning.
class GalleryPassthroughView: UIView {
    weak var coordinator: GalleryGestureView.Coordinator?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // In edit mode, pass all touches through to SwiftUI views beneath
        if coordinator?.isEditMode == true {
            return nil
        }
        return super.hitTest(point, with: event)
    }
}

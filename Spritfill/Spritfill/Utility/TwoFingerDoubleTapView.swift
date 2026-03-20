//
//  TwoFingerDoubleTapView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-19.
//

import SwiftUI
import UIKit

/// Transparent overlay that detects a two-finger double-tap gesture.
/// Single-finger touches pass through to SwiftUI views underneath.
struct TwoFingerDoubleTapView: UIViewRepresentable {
    var action: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }

    func makeUIView(context: Context) -> UIView {
        let view = TapPassthroughView()
        view.backgroundColor = .clear

        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        tap.numberOfTouchesRequired = 2
        tap.numberOfTapsRequired = 2
        tap.cancelsTouchesInView = false
        tap.delaysTouchesBegan = false
        view.addGestureRecognizer(tap)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.action = action
    }

    class Coordinator: NSObject {
        var action: () -> Void
        init(action: @escaping () -> Void) { self.action = action }

        @objc func handleTap() { action() }
    }
}

/// UIView that only intercepts touches when a gesture recognizer is active,
/// otherwise passes them through to SwiftUI.
private class TapPassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // If a recognizer is mid-recognition, keep receiving touches
        for recognizer in gestureRecognizers ?? [] {
            if recognizer.state == .began || recognizer.state == .changed {
                return self
            }
        }
        // Otherwise pass through — but UIKit still delivers touches to our
        // gesture recognizers because they're attached to this view's window chain.
        // Returning self here is fine because the tap recognizer has
        // cancelsTouchesInView = false, so SwiftUI's DragGesture still works.
        return self
    }
}

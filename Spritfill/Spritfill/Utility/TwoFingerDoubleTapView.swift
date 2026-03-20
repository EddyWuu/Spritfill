//
//  TwoFingerDoubleTapView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-19.
//

import SwiftUI
import UIKit

/// Transparent overlay that detects two-finger gestures:
/// - Two-finger double-tap (e.g. undo)
/// - Two-finger pan (always pans regardless of selected tool)
/// Single-finger touches pass through to SwiftUI views underneath.
struct TwoFingerDoubleTapView: UIViewRepresentable {
    var doubleTapAction: () -> Void
    var onPan: ((CGSize) -> Void)?
    var onPanEnd: (() -> Void)?

    /// Convenience init for just the double-tap (backward compatible)
    init(action: @escaping () -> Void) {
        self.doubleTapAction = action
        self.onPan = nil
        self.onPanEnd = nil
    }

    /// Full init with double-tap + pan
    init(doubleTapAction: @escaping () -> Void,
         onPan: @escaping (CGSize) -> Void,
         onPanEnd: @escaping () -> Void) {
        self.doubleTapAction = doubleTapAction
        self.onPan = onPan
        self.onPanEnd = onPanEnd
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(doubleTapAction: doubleTapAction, onPan: onPan, onPanEnd: onPanEnd)
    }

    func makeUIView(context: Context) -> UIView {
        let view = TwoFingerPassthroughView()
        view.backgroundColor = .clear
        view.isMultipleTouchEnabled = true

        // Two-finger double-tap
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        tap.numberOfTouchesRequired = 2
        tap.numberOfTapsRequired = 2
        tap.cancelsTouchesInView = false
        tap.delaysTouchesBegan = false
        view.addGestureRecognizer(tap)

        // Two-finger pan
        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        pan.minimumNumberOfTouches = 2
        pan.maximumNumberOfTouches = 2
        pan.cancelsTouchesInView = false
        pan.delaysTouchesBegan = false
        pan.delegate = context.coordinator
        view.addGestureRecognizer(pan)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.doubleTapAction = doubleTapAction
        context.coordinator.onPan = onPan
        context.coordinator.onPanEnd = onPanEnd
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var doubleTapAction: () -> Void
        var onPan: ((CGSize) -> Void)?
        var onPanEnd: (() -> Void)?

        init(doubleTapAction: @escaping () -> Void,
             onPan: ((CGSize) -> Void)?,
             onPanEnd: (() -> Void)?) {
            self.doubleTapAction = doubleTapAction
            self.onPan = onPan
            self.onPanEnd = onPanEnd
        }

        @objc func handleTap() { doubleTapAction() }

        @objc func handlePan(_ g: UIPanGestureRecognizer) {
            switch g.state {
            case .changed:
                let t = g.translation(in: g.view)
                onPan?(CGSize(width: t.x, height: t.y))
                g.setTranslation(.zero, in: g.view)
            case .ended, .cancelled:
                onPanEnd?()
            default: break
            }
        }

        // Allow pan + tap to coexist with each other and with SwiftUI gestures
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}

/// UIView that returns self for hitTest so gesture recognizers always receive touches.
/// cancelsTouchesInView = false on the recognizers ensures SwiftUI's single-finger
/// DragGesture still works normally.
private class TwoFingerPassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
}

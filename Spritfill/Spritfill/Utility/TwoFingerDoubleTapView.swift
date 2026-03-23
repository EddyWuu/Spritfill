//
//  TwoFingerDoubleTapView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-19.
//

import SwiftUI
import UIKit

// Transparent overlay that detects gestures via UIKit for minimum latency:
// - Two-finger double-tap (e.g. undo)
// - Two-finger pan (always pans regardless of selected tool)
// - Pinch-to-zoom
// - Single-finger touch/drag (drawing, erasing, eyedropper, panning)
// Using UIKit gesture recognizers eliminates the SwiftUI gesture→UIKit bridge delay.
struct TwoFingerDoubleTapView: UIViewRepresentable {
    var doubleTapAction: () -> Void
    var onPan: ((CGSize) -> Void)?
    var onPanEnd: (() -> Void)?
    var onPinch: ((CGFloat) -> Void)?
    var onPinchEnd: (() -> Void)?
    // Single-finger callbacks (for drawing tools) — replaces SwiftUI DragGesture
    // isPencilTouch: true when the touch came from Apple Pencil
    var onSingleTouchBegan: ((CGPoint, Bool) -> Void)?
    var onSingleTouchMoved: ((CGPoint, Bool) -> Void)?
    var onSingleTouchEnded: ((CGPoint, Bool) -> Void)?

    // Convenience init for just the double-tap (backward compatible)
    init(action: @escaping () -> Void) {
        self.doubleTapAction = action
    }

    // Full init with double-tap + pan
    init(doubleTapAction: @escaping () -> Void,
         onPan: @escaping (CGSize) -> Void,
         onPanEnd: @escaping () -> Void) {
        self.doubleTapAction = doubleTapAction
        self.onPan = onPan
        self.onPanEnd = onPanEnd
    }
    
    // Init with double-tap + pan + pinch (no single-touch — for Recreate view)
    init(doubleTapAction: @escaping () -> Void,
         onPan: @escaping (CGSize) -> Void,
         onPanEnd: @escaping () -> Void,
         onPinch: @escaping (CGFloat) -> Void,
         onPinchEnd: @escaping () -> Void) {
        self.doubleTapAction = doubleTapAction
        self.onPan = onPan
        self.onPanEnd = onPanEnd
        self.onPinch = onPinch
        self.onPinchEnd = onPinchEnd
    }
    
    // Full init with all gestures
    init(doubleTapAction: @escaping () -> Void,
         onPan: @escaping (CGSize) -> Void,
         onPanEnd: @escaping () -> Void,
         onPinch: @escaping (CGFloat) -> Void,
         onPinchEnd: @escaping () -> Void,
         onSingleTouchBegan: @escaping (CGPoint, Bool) -> Void,
         onSingleTouchMoved: @escaping (CGPoint, Bool) -> Void,
         onSingleTouchEnded: @escaping (CGPoint, Bool) -> Void) {
        self.doubleTapAction = doubleTapAction
        self.onPan = onPan
        self.onPanEnd = onPanEnd
        self.onPinch = onPinch
        self.onPinchEnd = onPinchEnd
        self.onSingleTouchBegan = onSingleTouchBegan
        self.onSingleTouchMoved = onSingleTouchMoved
        self.onSingleTouchEnded = onSingleTouchEnded
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(doubleTapAction: doubleTapAction, onPan: onPan, onPanEnd: onPanEnd,
                    onPinch: onPinch, onPinchEnd: onPinchEnd,
                    onSingleTouchBegan: onSingleTouchBegan,
                    onSingleTouchMoved: onSingleTouchMoved,
                    onSingleTouchEnded: onSingleTouchEnded)
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
        tap.delaysTouchesEnded = false
        view.addGestureRecognizer(tap)

        // Two-finger pan
        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        pan.minimumNumberOfTouches = 2
        pan.maximumNumberOfTouches = 2
        pan.cancelsTouchesInView = false
        pan.delaysTouchesBegan = false
        pan.delaysTouchesEnded = false
        pan.delegate = context.coordinator
        view.addGestureRecognizer(pan)

        // Pinch-to-zoom
        let pinch = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(_:)))
        pinch.cancelsTouchesInView = false
        pinch.delaysTouchesBegan = false
        pinch.delaysTouchesEnded = false
        pinch.delegate = context.coordinator
        view.addGestureRecognizer(pinch)
        
        // Single-finger pan (for drawing — fires immediately, only when callbacks provided)
        if context.coordinator.onSingleTouchBegan != nil {
            let singlePan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSinglePan(_:)))
            singlePan.minimumNumberOfTouches = 1
            singlePan.maximumNumberOfTouches = 1
            singlePan.cancelsTouchesInView = false
            singlePan.delaysTouchesBegan = false
            singlePan.delaysTouchesEnded = false
            singlePan.delegate = context.coordinator
            view.addGestureRecognizer(singlePan)
            context.coordinator.singlePanGesture = singlePan
        }
        
        if context.coordinator.onSingleTouchBegan != nil {
            view.coordinator = context.coordinator
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.doubleTapAction = doubleTapAction
        context.coordinator.onPan = onPan
        context.coordinator.onPanEnd = onPanEnd
        context.coordinator.onPinch = onPinch
        context.coordinator.onPinchEnd = onPinchEnd
        context.coordinator.onSingleTouchBegan = onSingleTouchBegan
        context.coordinator.onSingleTouchMoved = onSingleTouchMoved
        context.coordinator.onSingleTouchEnded = onSingleTouchEnded
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var doubleTapAction: () -> Void
        var onPan: ((CGSize) -> Void)?
        var onPanEnd: (() -> Void)?
        var onPinch: ((CGFloat) -> Void)?
        var onPinchEnd: (() -> Void)?
        var onSingleTouchBegan: ((CGPoint, Bool) -> Void)?
        var onSingleTouchMoved: ((CGPoint, Bool) -> Void)?
        var onSingleTouchEnded: ((CGPoint, Bool) -> Void)?
        
        var singlePanGesture: UIPanGestureRecognizer?
        private var pinchStartScale: CGFloat = 1.0
        // Track if touchesBegan already fired the initial callback
        var touchBeganFired = false
        // Track whether the current single-finger touch is from Apple Pencil
        var currentTouchIsPencil = false

        init(doubleTapAction: @escaping () -> Void,
             onPan: ((CGSize) -> Void)?,
             onPanEnd: (() -> Void)?,
             onPinch: ((CGFloat) -> Void)?,
             onPinchEnd: (() -> Void)?,
             onSingleTouchBegan: ((CGPoint, Bool) -> Void)?,
             onSingleTouchMoved: ((CGPoint, Bool) -> Void)?,
             onSingleTouchEnded: ((CGPoint, Bool) -> Void)?) {
            self.doubleTapAction = doubleTapAction
            self.onPan = onPan
            self.onPanEnd = onPanEnd
            self.onPinch = onPinch
            self.onPinchEnd = onPinchEnd
            self.onSingleTouchBegan = onSingleTouchBegan
            self.onSingleTouchMoved = onSingleTouchMoved
            self.onSingleTouchEnded = onSingleTouchEnded
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
        
        @objc func handlePinch(_ g: UIPinchGestureRecognizer) {
            switch g.state {
            case .began:
                pinchStartScale = 1.0
            case .changed:
                let delta = g.scale / pinchStartScale
                pinchStartScale = g.scale
                onPinch?(delta)
            case .ended, .cancelled:
                onPinchEnd?()
            default: break
            }
        }
        
        @objc func handleSinglePan(_ g: UIPanGestureRecognizer) {
            guard let view = g.view else { return }
            let location = g.location(in: view)
            let isPencil = currentTouchIsPencil
            
            switch g.state {
            case .began:
                // touchesBegan already fired onSingleTouchBegan — don't duplicate
                break
            case .changed:
                onSingleTouchMoved?(location, isPencil)
            case .ended:
                onSingleTouchEnded?(location, isPencil)
                touchBeganFired = false
            case .cancelled, .failed:
                onSingleTouchEnded?(location, isPencil)
                touchBeganFired = false
            default: break
            }
        }
        
        // Handle taps (touch down + up without significant movement)
        func handleSingleTap(at point: CGPoint, isPencil: Bool) {
            onSingleTouchBegan?(point, isPencil)
            onSingleTouchEnded?(point, isPencil)
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool {
            // Single-finger pan should NOT coexist with two-finger pan/pinch
            if gestureRecognizer == singlePanGesture || other == singlePanGesture {
                // Allow single pan with the double-tap recognizer (they're different gesture types)
                if other is UITapGestureRecognizer || gestureRecognizer is UITapGestureRecognizer {
                    return true
                }
                return false
            }
            return true
        }
    }
}

// UIView that always returns self from hitTest so gesture recognizers receive all touches.
// Touch delivery to SwiftUI is handled by the single-finger pan recognizer callbacks.
private class TwoFingerPassthroughView: UIView {
    weak var coordinator: TwoFingerDoubleTapView.Coordinator?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
    
    // Detect immediate touch-down for tap-like interactions (single pixel placement)
    // UIPanGestureRecognizer requires some movement before .began fires, so
    // we use touchesBegan to fire the callback immediately on contact.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first, (event?.allTouches?.count ?? 0) <= 1 {
            let location = touch.location(in: self)
            let isPencil = touch.type == .pencil
            coordinator?.currentTouchIsPencil = isPencil
            coordinator?.touchBeganFired = true
            coordinator?.onSingleTouchBegan?(location, isPencil)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // If the pan gesture never fired (pure tap, no movement), fire end callback here
        if let touch = touches.first, coordinator?.touchBeganFired == true {
            // Check if the single pan gesture is in a state that means it handled the end
            if let panState = coordinator?.singlePanGesture?.state,
               panState == .changed || panState == .ended {
                // Pan gesture handled it — don't duplicate
            } else {
                let location = touch.location(in: self)
                let isPencil = coordinator?.currentTouchIsPencil ?? false
                coordinator?.onSingleTouchEnded?(location, isPencil)
                coordinator?.touchBeganFired = false
            }
        }
    }
}

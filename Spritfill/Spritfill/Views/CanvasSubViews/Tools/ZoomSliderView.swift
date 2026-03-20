//
//  ZoomSliderView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-06.
//

import SwiftUI

struct ZoomSliderView: View {
    @ObservedObject var canvasVM: CanvasViewModel

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "minus.magnifyingglass")
                .font(.caption)
                .foregroundColor(.secondary)

            Slider(
                value: Binding(
                    get: { canvasVM.zoomScale },
                    set: { newValue in
                        let lo = canvasVM.minimumZoomScale
                        let hi = canvasVM.maximumZoomScale
                        canvasVM.zoomScale = newValue.clamped(to: lo...hi)
                    }
                ),
                in: canvasVM.minimumZoomScale...canvasVM.maximumZoomScale
            )

            Image(systemName: "plus.magnifyingglass")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

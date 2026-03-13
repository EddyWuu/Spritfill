//
//  RecreateZoomSliderView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-13.
//

import SwiftUI

struct RecreateZoomSliderView: View {
    @ObservedObject var viewModel: RecreateCanvasViewModel

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "minus.magnifyingglass")
                .font(.caption)
                .foregroundColor(.secondary)

            Slider(
                value: Binding(
                    get: { viewModel.zoomScale },
                    set: { newValue in
                        let lo = viewModel.minimumZoomScale
                        let hi = viewModel.maximumZoomScale
                        viewModel.zoomScale = newValue.clamped(to: lo...hi)
                    }
                ),
                in: viewModel.minimumZoomScale...viewModel.maximumZoomScale
            )

            Image(systemName: "plus.magnifyingglass")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

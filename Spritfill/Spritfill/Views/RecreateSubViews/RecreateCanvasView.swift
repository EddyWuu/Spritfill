//
//  RecreateCanvasView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-08-18.
//

import SwiftUI

struct RecreateCanvasView: View {
    let sprite: RecreatableArtModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Recreate \(sprite.name)")
                .font(.title)

            Image(uiImage: sprite.thumbnail)
                .resizable()
                .scaledToFit()
                .frame(height: 150)

            Text("Choose a size to begin:")
                .font(.headline)

            ForEach(sprite.availableSizes, id: \.self) { size in
                Button(action: {
                    // handle recreate processs here
                }) {
                    Text("\(size.dimensions.width)x\(size.dimensions.height)")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }
            }

            Spacer()
        }
        .padding()
    }
}

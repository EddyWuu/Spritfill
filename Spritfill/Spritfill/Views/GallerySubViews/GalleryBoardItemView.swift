//
//  GalleryBoardItemView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import SwiftUI

struct GalleryBoardItemView: View {
    
    @ObservedObject var viewModel: GalleryViewModel
    let item: GalleryBoardItem
    
    @State private var dragOffset: CGSize = .zero
    @State private var resizeStartSize: CGFloat = 0
    
    var body: some View {
        let size = item.displaySize
        
        ZStack(alignment: .topTrailing) {
            // Sprite image
            if let image = viewModel.thumbnail(for: item.id) {
                Image(uiImage: image)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: size, height: size)
            }
            
            // Edit mode overlays
            if viewModel.isEditMode {
                // Archive button (top-left)
                Button(action: {
                    viewModel.archiveItem(id: item.id)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.red).frame(width: 20, height: 20))
                }
                .offset(x: 4, y: -4)
                
                // Resize handle (bottom-right)
                resizeHandle
            }
        }
        .position(
            x: item.position.x + (viewModel.isEditMode ? dragOffset.width : 0),
            y: item.position.y + (viewModel.isEditMode ? dragOffset.height : 0)
        )
        .gesture(viewModel.isEditMode ? dragGesture : nil)
    }
    
    // MARK: - Resize handle
    
    private var resizeHandle: some View {
        Image(systemName: "arrow.up.left.and.arrow.down.right")
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 24, height: 24)
            .background(Circle().fill(Color.blue.opacity(0.8)))
            .offset(x: 4, y: item.displaySize - 20)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if resizeStartSize == 0 {
                            resizeStartSize = item.displaySize
                        }
                        let delta = max(value.translation.width, value.translation.height)
                        let newSize = resizeStartSize + delta
                        viewModel.resizeItem(id: item.id, to: newSize)
                    }
                    .onEnded { _ in
                        resizeStartSize = 0
                    }
            )
    }
    
    // MARK: - Drag gesture
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                let newPosition = CGPoint(
                    x: item.position.x + value.translation.width,
                    y: item.position.y + value.translation.height
                )
                viewModel.moveItem(id: item.id, to: newPosition)
                dragOffset = .zero
            }
    }
}

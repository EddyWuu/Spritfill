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
    
    private var isSelected: Bool {
        viewModel.selectedItemID == item.id
    }
    
    private var isResizing: Bool {
        viewModel.resizingItemID == item.id
    }
    
    var body: some View {
        let size = item.displaySize
        
        ZStack {
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
        }
        .background {
            // Edit mode background box (slightly larger than the image)
            if viewModel.isEditMode {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(isResizing ? 0.25 : (isSelected ? 0.15 : 0.08)))
                    .stroke(isResizing ? Color.white.opacity(0.8) : Color.blue.opacity(isSelected ? 0.5 : 0.2),
                            lineWidth: isResizing ? 2.5 : (isSelected ? 2 : 1))
                    .padding(-8)
            }
        }
        .overlay(alignment: .topTrailing) {
            // Edit mode overlays
            if viewModel.isEditMode {
                // Archive button (top-right)
                Button(action: {
                    viewModel.archiveItem(id: item.id)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.red).frame(width: 20, height: 20))
                }
                .offset(x: 4, y: -4)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if viewModel.isEditMode {
                // Resize toggle button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        viewModel.toggleResize(id: item.id)
                    }
                }) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(isResizing ? .blue : .white)
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(isResizing ? Color.white : Color.blue.opacity(0.8)))
                }
                .offset(x: 4, y: 4)
            }
        }
        .position(
            x: item.position.x + (viewModel.isEditMode && !isResizing ? dragOffset.width : 0),
            y: item.position.y + (viewModel.isEditMode && !isResizing ? dragOffset.height : 0)
        )
        .onTapGesture {
            if viewModel.isEditMode && !isResizing {
                withAnimation(.easeInOut(duration: 0.15)) {
                    viewModel.selectItem(id: item.id)
                }
            }
        }
        .highPriorityGesture(viewModel.isEditMode ? itemDragGesture : nil)
    }
    
    // MARK: - Combined drag gesture (moves OR resizes depending on mode)
    
    private var itemDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if isResizing {
                    // Resize: drag right/down to grow, left/up to shrink
                    if resizeStartSize == 0 {
                        resizeStartSize = item.displaySize
                    }
                    let delta = max(value.translation.width, value.translation.height)
                    let newSize = resizeStartSize + delta
                    viewModel.resizeItem(id: item.id, to: newSize)
                } else {
                    // Move
                    dragOffset = value.translation
                }
            }
            .onEnded { value in
                if isResizing {
                    resizeStartSize = 0
                } else {
                    let newPosition = CGPoint(
                        x: item.position.x + value.translation.width,
                        y: item.position.y + value.translation.height
                    )
                    viewModel.moveItem(id: item.id, to: newPosition)
                    dragOffset = .zero
                }
            }
    }
}

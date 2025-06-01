//
//  ProjectCreateView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-30.
//

import SwiftUI

//struct ProjectCreateView: View {
//    
//    @ObservedObject var viewModel: ProjectViewModel
//    @Environment(\.dismiss) private var dismiss
//    @Binding var isPresented: Bool
//    
//    @State private var zoomScale: CGFloat = 1.0  // track zoom level
//    @State private var lastScale: CGFloat = 1.0  // track the last pinch scale
//    
//    @State private var pinchCenter: CGPoint = .zero
//    
//    var body: some View {
//        
//        VStack(spacing: 0) {
//            
//            HStack {
//                Button(action: {
//                    isPresented = false
//                }) {
//                    Text("Back")
//                        .foregroundColor(.blue)
//                        .padding(.horizontal)
//                }
//                
//                Spacer()
//                
//            }
//            .padding()
//            
//            Divider()
//            
//            GeometryReader { geometry in
//                
//                ZStack {
//                    
//                    ProjectCanvasView(viewModel: viewModel, zoomScale: $zoomScale)
//                        .frame(width: geometry.size.width, height: geometry.size.height * 0.7)
//                        .contentShape(Rectangle())
//                        .gesture(
//                            MagnificationGesture()
//                                .onChanged { scale in
//                                    zoomScale = max(0.5, min(lastScale * scale, 5.0))
//                                }
//                                .onEnded { _ in
//                                    lastScale = zoomScale
//                                }
//                        )
//                }
//            }
//            
//            Divider()
//            
//            VStack {
//                HStack(spacing: 20) {
//                    Button(action: { viewModel.selectTool(.pencil) }) {
//                        Image(systemName: "pencil")
//                            .padding()
//                            .background(viewModel.selectedTool == .pencil ? Color.yellow : Color.clear)
//                            .clipShape(Circle())
//                    }
//                    
//                    Button(action: { viewModel.selectTool(.eraser) }) {
//                        Image(systemName: "eraser")
//                            .padding()
//                            .background(viewModel.selectedTool == .eraser ? Color.yellow : Color.clear)
//                            .clipShape(Circle())
//                    }
//
//                    Button(action: { viewModel.selectTool(.fill) }) {
//                        Image(systemName: "paintbrush.fill")
//                            .padding()
//                            .background(viewModel.selectedTool == .fill ? Color.yellow : Color.clear)
//                            .clipShape(Circle())
//                    }
//                }
//                .padding()
//            }
//            .frame(height: 100)
//            .background(Color(UIColor.systemGray6))
//        }
//
//        .edgesIgnoringSafeArea(.bottom)
//    }
//}

struct ProjectCreateView: View {
    @ObservedObject var viewModel: ProjectViewModel

    var body: some View {
        Text("Editing project")
    }
}

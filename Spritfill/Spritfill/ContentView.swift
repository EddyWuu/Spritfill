//
//  ContentView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            CanvasView()
                .tag(0)
                .tabItem {
                    Label("Canvas", systemImage: "paintbrush")
                }
            
            LazyTab { GalleryView() }
                .tag(1)
                .tabItem {
                    Label("Gallery", systemImage: "photo.on.rectangle")
                }
            
            LazyTab { RecreateView() }
                .tag(2)
                .tabItem {
                    Label("Recreate", systemImage: "pencil")
                }
            
            LazyTab { CatalogView() }
                .tag(3)
                .tabItem {
                    Label("Catalog", systemImage: "books.vertical")
                }
            
            LazyTab { StoreView() }
                .tag(4)
                .tabItem {
                    Label("Pro", systemImage: "star.fill")
                }
        }
    }
}

/// Defers creation of a heavy tab view until it first appears.
/// After first load, the view stays alive (not re-created on every tab switch).
private struct LazyTab<Content: View>: View {
    let build: () -> Content
    @State private var hasAppeared = false
    
    init(@ViewBuilder _ build: @escaping () -> Content) {
        self.build = build
    }
    
    var body: some View {
        if hasAppeared {
            build()
        } else {
            Color.clear
                .onAppear { hasAppeared = true }
        }
    }
}

#Preview {
    ContentView()
}

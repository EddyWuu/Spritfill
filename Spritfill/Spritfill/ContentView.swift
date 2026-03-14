//
//  ContentView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            
            CanvasView()
                .tabItem {
                    Label("Canvas", systemImage: "square.and.arrow.up")
                }
            
            GalleryView()
                .tabItem {
                    Label("Gallery", systemImage: "photo")
                }
            
            RecreateView()
                .tabItem {
                    Label("Recreate", systemImage: "pencil")
                }
            
            DownloadsView()
                .tabItem {
                    Label("Downloads", systemImage: "arrow.down.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}

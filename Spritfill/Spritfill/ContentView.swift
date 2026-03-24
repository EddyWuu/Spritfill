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
                    Label("Canvas", systemImage: "paintbrush")
                }
            
            GalleryView()
                .tabItem {
                    Label("Gallery", systemImage: "photo.on.rectangle")
                }
            
            RecreateView()
                .tabItem {
                    Label("Recreate", systemImage: "pencil")
                }
            
            CatalogView()
                .tabItem {
                    Label("Catalog", systemImage: "books.vertical")
                }
            
            StoreView()
                .tabItem {
                    Label("Support", systemImage: "heart.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}

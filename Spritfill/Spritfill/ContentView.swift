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
            
            CommunityView()
                .tabItem {
                    Label("Community", systemImage: "bubble.left.and.bubble.right")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}

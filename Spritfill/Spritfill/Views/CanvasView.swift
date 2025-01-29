//
//  CanvasView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-01-24.
//

import SwiftUI

struct CanvasView: View {
    
    // place holder project
    @State private var projects: [String] = ["Project 1", "Project 2", "Project 3", "Project 4"]
    @State private var isNewProjectSheetPresented: Bool = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    
                    // create new proj
                    Button(action: {
                        isNewProjectSheetPresented = true
                     }) {
                         VStack {
                             Image(systemName: "plus")
                                 .resizable()
                                 .scaledToFit()
                                 .frame(width: 40, height: 40)
                                 .padding()
                             Text("New Project")
                                 .font(.caption)
                         }
                         .frame(height: 120)
                         .frame(maxWidth: .infinity)
                         .background(Color.blue.opacity(0.2))
                         .cornerRadius(12)
                         .padding(.horizontal)
                     }
                     .sheet(isPresented: $isNewProjectSheetPresented) {
                         NewProjectSetUpView(isPresented: $isNewProjectSheetPresented)
                     }

                    // existing proj
                    ForEach(projects, id: \.self) { project in
                        VStack {
                            // placeholder image
                            Image(systemName: "doc.text")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                            Text(project)
                                .font(.caption)
                        }
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationTitle("Canvas")
        }
    }
}

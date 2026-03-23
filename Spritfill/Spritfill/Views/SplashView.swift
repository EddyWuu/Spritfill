//
//  SplashView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-22.
//

import SwiftUI

struct SplashView: View {
    
    @State private var logoOpacity: Double = 0
    @State private var logoScale: CGFloat = 0.8
    @State private var isFinished = false
    
    var body: some View {
        if isFinished {
            ContentView()
        } else {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image("SplashLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                    
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    logoOpacity = 1
                    logoScale = 1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        logoOpacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isFinished = true
                    }
                }
            }
        }
    }
}

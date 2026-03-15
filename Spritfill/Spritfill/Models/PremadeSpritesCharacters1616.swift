//
//  PremadeSprites.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import Foundation

// MARK: - All 16x16 Character Trios

extension PremadeSprites {
    
    // MARK: - Knight Idle (16x16)
    
    static let knightIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#c0cbdc"
        let d = "#657392"
        let h = "#424c6e"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let v = "#0069aa"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, d, a, a, a, a, d, o, c, c, c, c,
            c, c, c, c, o, d, v, v, v, v, d, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, d, a, a, a, a, d, o, c, c, c, c,
            c, c, c, o, d, a, a, a, a, a, a, d, o, c, c, c,
            c, c, c, o, h, d, a, a, a, a, d, h, o, c, c, c,
            c, c, o, s, o, d, a, a, a, a, d, o, s, o, c, c,
            c, c, c, c, c, o, d, a, a, d, o, c, c, c, c, c,
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c,
            c, c, c, c, c, o, h, o, o, h, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "knight_idle", name: "Knight — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Knight", groupOrder: 0)
    }()
    
    static let knightRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#c0cbdc"
        let d = "#657392"
        let h = "#424c6e"
        let s = "#bf6f4a"
        let k = "#131313"
        let b = "#391f21"
        let v = "#0069aa"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, d, a, a, a, a, d, o, c, c, c, c,
            c, c, c, c, o, d, v, v, v, v, d, o, c, c, c, c,
            c, c, c, c, o, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, d, a, a, a, a, d, o, c, c, c, c,
            c, c, c, o, d, a, a, a, a, a, a, d, o, c, c, c,
            c, c, o, s, o, d, a, a, a, a, d, o, s, o, c, c,
            c, c, c, c, c, o, d, a, a, d, o, c, c, c, c, c,
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c,
            c, c, c, c, c, o, h, o, o, h, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "knight_rest", name: "Knight — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Knight", groupOrder: 1)
    }()
    
    static let knightAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#c0cbdc"
        let d = "#657392"
        let h = "#424c6e"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let v = "#0069aa"
        let w = "#c0cbdc"
        let g = "#edab50"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, w, w, c,
            c, c, c, c, c, c, c, c, c, c, c, c, w, w, c, c,
            c, c, c, c, c, o, o, o, o, o, o, w, w, c, c, c,
            c, c, c, c, o, d, a, a, a, a, d, g, g, c, c, c,
            c, c, c, c, o, d, v, v, v, v, d, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, d, a, a, a, a, d, o, c, c, c, c,
            c, c, c, o, d, a, a, a, a, a, a, d, o, c, c, c,
            c, c, c, o, h, d, a, a, a, a, d, h, o, c, c, c,
            c, c, c, c, o, o, d, a, a, d, o, s, o, c, c, c,
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c,
            c, c, c, c, o, h, o, o, o, h, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, o, b, b, o, c, c, o, b, b, o, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "knight_attack", name: "Knight — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Knight", groupOrder: 2)
    }()
    
    // MARK: - Wizard Idle (16x16)
    
    static let wizardIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let r = "#3003d9"
        let p = "#7a09fa"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let h = "#c0cbdc"
        let w = "#5d2c28"
        let y = "#ffeb57"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, y, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, o, p, o, c, c, c, c, c, c, c,
            c, c, c, c, c, o, p, p, p, o, c, c, c, c, c, c,
            c, c, c, c, o, p, p, p, p, p, o, c, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, o, s, s, s, s, s, s, o, c, c, c, c,
            c, c, c, c, c, o, h, h, h, h, o, c, c, c, c, c,
            c, c, c, c, o, p, p, p, p, p, p, o, c, c, c, c,
            c, c, w, o, r, p, p, p, p, p, p, r, o, c, c, c,
            c, c, w, o, s, o, p, p, p, p, o, s, o, c, c, c,
            c, c, w, c, c, o, r, p, p, r, o, c, c, c, c, c,
            c, c, w, c, c, o, r, r, r, r, o, c, c, c, c, c,
            c, c, y, c, c, o, r, r, r, r, o, c, c, c, c, c,
            c, c, c, c, c, o, r, o, o, r, o, c, c, c, c, c,
            c, c, c, c, o, r, r, o, o, r, r, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "wizard_idle", name: "Wizard — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Wizard", groupOrder: 0)
    }()
    
    static let wizardRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let r = "#3003d9"
        let p = "#7a09fa"
        let s = "#bf6f4a"
        let k = "#131313"
        let h = "#c0cbdc"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, o, p, o, c, c, c, c, c, c, c,
            c, c, c, c, c, o, p, p, p, o, c, c, c, c, c, c,
            c, c, c, c, o, p, p, p, p, p, o, c, c, c, c, c,
            c, c, c, c, o, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, o, s, s, s, s, s, s, o, c, c, c, c,
            c, c, c, c, c, o, h, h, h, h, o, c, c, c, c, c,
            c, c, c, c, o, p, p, p, p, p, p, o, c, c, c, c,
            c, c, c, o, r, p, p, p, p, p, p, r, o, c, c, c,
            c, c, c, o, s, o, p, p, p, p, o, s, o, c, c, c,
            c, c, c, c, c, o, r, p, p, r, o, c, c, c, c, c,
            c, c, c, c, c, o, r, r, r, r, o, c, c, c, c, c,
            c, c, c, c, c, o, r, r, r, r, o, c, c, c, c, c,
            c, c, c, c, c, o, r, o, o, r, o, c, c, c, c, c,
            c, c, c, c, o, r, r, o, o, r, r, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "wizard_rest", name: "Wizard — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Wizard", groupOrder: 1)
    }()
    
    static let wizardAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let r = "#3003d9"
        let p = "#7a09fa"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let h = "#c0cbdc"
        let w = "#5d2c28"
        let y = "#ffeb57"
        let f = "#0cf1ff"
        let m = "#00cdf9"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, y, c, c, c, c, f, c, f, c,
            c, c, c, c, c, c, o, p, o, c, c, c, c, f, c, c,
            c, c, c, c, c, o, p, p, p, o, c, c, f, m, f, c,
            c, c, c, c, o, p, p, p, p, p, o, c, c, f, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, f, c, f, c,
            c, c, c, c, o, s, s, s, s, s, s, o, c, c, c, c,
            c, c, c, c, c, o, h, h, h, h, o, c, c, c, c, c,
            c, c, c, c, o, p, p, p, p, p, p, o, c, c, c, c,
            c, c, w, o, r, p, p, p, p, p, p, r, o, s, o, c,
            c, c, w, o, s, o, p, p, p, p, o, c, s, o, c, c,
            c, c, w, c, c, o, r, p, p, r, o, c, c, c, c, c,
            c, c, w, c, c, o, r, r, r, r, o, c, c, c, c, c,
            c, c, y, c, c, o, r, r, r, r, o, c, c, c, c, c,
            c, c, c, c, o, r, o, o, o, o, r, o, c, c, c, c,
            c, c, c, o, r, r, o, c, c, o, r, r, o, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "wizard_attack", name: "Wizard — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Wizard", groupOrder: 2)
    }()
    
    // MARK: - Berserker Idle (16x16)
    
    static let berserkerIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let s = "#bf6f4a"
        let h = "#891e2b"
        let e = "#ffffff"
        let k = "#131313"
        let p = "#5d2c28"
        let t = "#b86f50"
        let g = "#8a4836"
        let f = "#391f21"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, o, s, s, s, s, s, s, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, t, t, g, g, t, t, o, c, c, c, c,
            c, c, c, o, s, t, t, t, t, t, t, s, o, c, c, c,
            c, c, c, o, s, o, t, t, t, t, o, s, o, c, c, c,
            c, c, c, c, c, o, g, g, g, g, o, c, c, c, c, c,
            c, c, c, c, c, o, p, p, p, p, o, c, c, c, c, c,
            c, c, c, c, c, o, p, o, o, p, o, c, c, c, c, c,
            c, c, c, c, o, p, p, o, o, p, p, o, c, c, c, c,
            c, c, c, c, o, f, f, o, o, f, f, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "berserker_idle", name: "Berserker — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Berserker", groupOrder: 0)
    }()
    
    static let berserkerRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let s = "#bf6f4a"
        let h = "#891e2b"
        let k = "#131313"
        let p = "#5d2c28"
        let t = "#b86f50"
        let g = "#8a4836"
        let f = "#391f21"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, o, s, s, s, s, s, s, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, t, t, g, g, t, t, o, c, c, c, c,
            c, c, c, o, s, t, t, t, t, t, t, s, o, c, c, c,
            c, c, c, o, s, o, t, t, t, t, o, s, o, c, c, c,
            c, c, c, c, c, o, g, g, g, g, o, c, c, c, c, c,
            c, c, c, c, c, o, p, p, p, p, o, c, c, c, c, c,
            c, c, c, c, c, o, p, o, o, p, o, c, c, c, c, c,
            c, c, c, c, o, f, f, o, o, f, f, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "berserker_rest", name: "Berserker — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Berserker", groupOrder: 1)
    }()
    
    static let berserkerAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let s = "#bf6f4a"
        let h = "#891e2b"
        let e = "#ffffff"
        let k = "#131313"
        let p = "#5d2c28"
        let t = "#b86f50"
        let g = "#8a4836"
        let f = "#391f21"
        let w = "#c0cbdc"
        let d = "#657392"
        let a = "#5d2c28"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, d, w, w, c, c,
            c, c, c, c, c, c, c, c, c, c, d, w, w, d, c, c,
            c, c, c, c, c, o, o, o, o, o, o, a, d, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, a, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, o, s, s, s, s, s, s, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, t, t, g, g, t, t, o, c, c, c, c,
            c, c, c, o, s, t, t, t, t, t, t, s, o, c, c, c,
            c, c, c, c, o, o, t, t, t, t, o, s, o, c, c, c,
            c, c, c, c, c, o, g, g, g, g, o, c, c, c, c, c,
            c, c, c, c, o, p, o, o, o, p, o, c, c, c, c, c,
            c, c, c, o, p, p, o, c, o, p, p, o, c, c, c, c,
            c, c, c, o, f, f, o, c, o, f, f, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "berserker_attack", name: "Berserker — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Berserker", groupOrder: 2)
    }()
    
    // MARK: - Samurai Idle (16x16)
    
    static let samuraiIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#c42430"  // red armor
        let d = "#891e2b"  // dark red
        let s = "#e4a672"  // skin
        let h = "#131313"  // hair
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let g = "#edab50"  // gold trim
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, g, a, a, a, a, g, o, c, c, c, c,
            c, c, c, o, d, a, a, g, g, a, a, d, o, c, c, c,
            c, c, c, o, d, a, a, a, a, a, a, d, o, c, c, c,
            c, c, o, s, o, d, a, a, a, a, d, o, s, o, c, c,
            c, c, c, c, c, o, d, a, a, d, o, c, c, c, c, c,
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "samurai_idle", name: "Samurai — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Samurai", groupOrder: 0)
    }()
    
    static let samuraiRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#c42430"
        let d = "#891e2b"
        let s = "#e4a672"
        let h = "#131313"
        let k = "#131313"
        let b = "#391f21"
        let g = "#edab50"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, g, a, a, a, a, g, o, c, c, c, c,
            c, c, c, o, d, a, a, g, g, a, a, d, o, c, c, c,
            c, c, o, s, o, d, a, a, a, a, d, o, s, o, c, c,
            c, c, c, c, c, o, d, a, a, d, o, c, c, c, c, c,
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "samurai_rest", name: "Samurai — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Samurai", groupOrder: 1)
    }()
    
    static let samuraiAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#c42430"
        let d = "#891e2b"
        let s = "#e4a672"
        let h = "#131313"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let g = "#edab50"
        let w = "#c0cbdc"  // katana blade
        let wd = "#657392"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, w, wd, c,
            c, c, c, c, c, c, c, c, c, c, c, c, w, wd, c, c,
            c, c, c, c, c, o, o, o, o, o, o, w, wd, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, g, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, g, a, a, a, a, g, o, c, c, c, c,
            c, c, c, o, d, a, a, g, g, a, a, d, o, c, c, c,
            c, c, c, o, d, a, a, a, a, a, a, d, s, o, c, c,
            c, c, c, c, o, o, d, a, a, d, o, s, o, c, c, c,
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c,
            c, c, c, c, o, b, o, o, o, b, o, c, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "samurai_attack", name: "Samurai — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Samurai", groupOrder: 2)
    }()
    
    // MARK: - Bowman (16x16)
    
    static let bowmanIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let t = "#33984b"  // green tunic
        let td = "#1e6f50"
        let s = "#bf6f4a"
        let h = "#5d2c28"  // brown hair
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#b86f50"  // bow wood
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, t, t, t, t, t, t, o, c, c, c, c,
            c, c, w, o, td, t, t, t, t, t, t, td, o, c, c, c,
            c, c, w, o, s, o, t, t, t, t, o, s, o, c, c, c,
            c, c, w, c, c, o, td, t, t, td, o, c, c, c, c, c,
            c, c, w, c, c, o, td, td, td, td, o, c, c, c, c, c,
            c, c, w, c, c, o, b, b, b, b, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "bowman_idle", name: "Bowman — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Bowman", groupOrder: 0)
    }()
    
    static let bowmanRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let t = "#33984b"
        let td = "#1e6f50"
        let s = "#bf6f4a"
        let h = "#5d2c28"
        let k = "#131313"
        let b = "#391f21"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, t, t, t, t, t, t, o, c, c, c, c,
            c, c, c, o, td, t, t, t, t, t, t, td, o, c, c, c,
            c, c, o, s, o, o, t, t, t, t, o, s, o, c, c, c,
            c, c, c, c, c, o, td, t, t, td, o, c, c, c, c, c,
            c, c, c, c, c, o, td, td, td, td, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "bowman_rest", name: "Bowman — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Bowman", groupOrder: 1)
    }()
    
    static let bowmanAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let t = "#33984b"
        let td = "#1e6f50"
        let s = "#bf6f4a"
        let h = "#5d2c28"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#b86f50"  // bow
        let ar = "#c0cbdc" // arrow
        let ad = "#657392"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, ar, ad, c,
            c, c, c, c, c, c, c, c, c, c, c, c, ar, ad, c, c,
            c, c, c, c, c, o, o, o, o, o, o, ar, ad, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, t, t, t, t, t, t, o, c, c, c, c,
            c, c, w, o, td, t, t, t, t, t, t, td, s, o, c, c,
            c, w, o, o, s, o, t, t, t, t, o, s, o, c, c, c,
            c, c, w, c, c, o, td, t, t, td, o, c, c, c, c, c,
            c, c, c, c, c, o, td, td, td, td, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, c, b, b, o, c, c, c, c,
            c, c, c, o, b, b, o, c, c, o, b, b, o, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "bowman_attack", name: "Bowman — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Bowman", groupOrder: 2)
    }()
    
    // MARK: - Viking (16x16)
    
    static let vikingIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#657392"  // grey fur/armor
        let ad = "#424c6e"
        let s = "#e4a672"
        let h = "#edab50"  // blonde hair
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let f = "#b86f50"  // fur brown
        let hm = "#c0cbdc" // helmet
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, hm, hm, hm, hm, c, c, c, c, c, c,
            c, c, c, c, c, o, hm, hm, hm, hm, o, c, c, c, c, c,
            c, c, c, c, o, ad, hm, ad, ad, hm, ad, o, c, c, c, c,
            c, c, c, c, o, h, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, o, h, s, s, s, s, s, h, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, f, a, a, a, a, f, o, c, c, c, c,
            c, c, c, o, f, a, a, a, a, a, a, f, o, c, c, c,
            c, c, o, s, o, ad, a, a, a, a, ad, o, s, o, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, f, f, f, f, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "viking_idle", name: "Viking — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Viking", groupOrder: 0)
    }()
    
    static let vikingRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#657392"
        let ad = "#424c6e"
        let s = "#e4a672"
        let h = "#edab50"
        let k = "#131313"
        let b = "#391f21"
        let f = "#b86f50"
        let hm = "#c0cbdc"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, hm, hm, hm, hm, c, c, c, c, c, c,
            c, c, c, c, c, o, hm, hm, hm, hm, o, c, c, c, c, c,
            c, c, c, c, o, ad, hm, ad, ad, hm, ad, o, c, c, c, c,
            c, c, c, c, o, h, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, o, h, s, s, s, s, s, h, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, f, a, a, a, a, f, o, c, c, c, c,
            c, c, c, o, f, a, a, a, a, a, a, f, o, c, c, c,
            c, c, o, s, o, ad, a, a, a, a, ad, o, s, o, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "viking_rest", name: "Viking — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Viking", groupOrder: 1)
    }()
    
    static let vikingAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#657392"
        let ad = "#424c6e"
        let s = "#e4a672"
        let h = "#edab50"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let f = "#b86f50"
        let hm = "#c0cbdc"
        let ax = "#c0cbdc"  // axe blade
        let axd = "#657392"
        let aw = "#5d2c28"  // axe handle
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, axd, ax, ax, c, c, c,
            c, c, c, c, c, c, c, c, c, axd, ax, ax, axd, c, c, c,
            c, c, c, c, c, c, hm, hm, hm, hm, aw, axd, c, c, c, c,
            c, c, c, c, c, o, hm, hm, hm, hm, aw, c, c, c, c, c,
            c, c, c, c, o, ad, hm, ad, ad, hm, ad, o, c, c, c, c,
            c, c, c, c, o, h, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, o, h, s, s, s, s, s, h, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, f, a, a, a, a, f, o, c, c, c, c,
            c, c, c, o, f, a, a, a, a, a, a, f, s, o, c, c,
            c, c, c, c, o, o, ad, a, a, ad, o, s, o, c, c, c,
            c, c, c, c, c, o, f, f, f, f, o, c, c, c, c, c,
            c, c, c, c, o, b, o, o, o, b, o, c, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "viking_attack", name: "Viking — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Viking", groupOrder: 2)
    }()
    
    // MARK: - Guan Dao (16x16) — Chinese warrior with guandao polearm
    
    static let guandaoIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#edab50"  // gold armor
        let ad = "#e07438"
        let s = "#e4a672"
        let h = "#131313"  // black hair
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let r = "#ea323c"  // red sash
        let p = "#5d2c28"  // pole
        let bl = "#c0cbdc" // blade
        
        let grid: [String] = [
            c, c, bl, bl, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, p, bl, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, p, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, p, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, p, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, p, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, p, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, p, c, o, a, a, r, r, a, a, o, c, c, c, c,
            c, c, p, o, ad, a, a, a, a, a, a, ad, o, c, c, c,
            c, c, c, o, s, o, a, a, a, a, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, b, b, b, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "guandao_idle", name: "Guandao — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Guandao", groupOrder: 0)
    }()
    
    static let guandaoRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#edab50"
        let ad = "#e07438"
        let s = "#e4a672"
        let h = "#131313"
        let k = "#131313"
        let b = "#391f21"
        let r = "#ea323c"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, a, a, r, r, a, a, o, c, c, c, c,
            c, c, c, o, ad, a, a, a, a, a, a, ad, o, c, c, c,
            c, c, o, s, o, o, a, a, a, a, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, b, b, b, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "guandao_rest", name: "Guandao — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Guandao", groupOrder: 1)
    }()
    
    static let guandaoAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#edab50"
        let ad = "#e07438"
        let s = "#e4a672"
        let h = "#131313"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let r = "#ea323c"
        let p = "#5d2c28"
        let bl = "#c0cbdc"
        let bld = "#657392"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, bl, bl, bld, c, c,
            c, c, c, c, c, c, c, c, c, c, bl, bld, p, c, c, c,
            c, c, c, c, c, o, o, o, o, o, p, p, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, a, a, r, r, a, a, o, c, c, c, c,
            c, c, c, o, ad, a, a, a, a, a, a, ad, s, o, c, c,
            c, c, c, c, o, o, a, a, a, a, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, b, b, b, o, c, c, c, c, c,
            c, c, c, c, o, b, o, o, o, b, o, c, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "guandao_attack", name: "Guandao — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Guandao", groupOrder: 2)
    }()
    
    // MARK: - Sorcerer (16x16)
    
    static let sorcererIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let r = "#622461"  // dark purple robe
        let p = "#93388f"  // purple robe
        let s = "#e4a672"
        let e = "#ffffff"
        let k = "#131313"
        let h = "#571c27"  // dark red hair
        let f = "#ea323c"  // fire
        let y = "#ffeb57"  // fire glow
        let b = "#391f21"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, p, p, p, p, p, p, o, c, c, c, c,
            c, c, c, o, r, p, p, p, p, p, p, r, o, c, c, c,
            c, c, c, o, s, o, p, p, p, p, o, s, o, c, c, c,
            c, c, c, c, c, o, r, p, p, r, o, c, c, c, c, c,
            c, c, c, c, c, o, r, r, r, r, o, c, c, c, c, c,
            c, c, c, c, c, o, r, r, r, r, o, c, c, c, c, c,
            c, c, c, c, c, o, r, r, r, r, o, c, c, c, c, c,
            c, c, c, c, c, o, r, o, o, r, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "sorcerer_idle", name: "Sorcerer — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Sorcerer", groupOrder: 0)
    }()
    
    static let sorcererRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let r = "#622461"
        let p = "#93388f"
        let s = "#e4a672"
        let k = "#131313"
        let h = "#571c27"
        let b = "#391f21"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, p, p, p, p, p, p, o, c, c, c, c,
            c, c, c, o, r, p, p, p, p, p, p, r, o, c, c, c,
            c, c, o, s, o, o, p, p, p, p, o, s, o, c, c, c,
            c, c, c, c, c, o, r, p, p, r, o, c, c, c, c, c,
            c, c, c, c, c, o, r, r, r, r, o, c, c, c, c, c,
            c, c, c, c, c, o, r, r, r, r, o, c, c, c, c, c,
            c, c, c, c, c, o, r, o, o, r, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "sorcerer_rest", name: "Sorcerer — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Sorcerer", groupOrder: 1)
    }()
    
    static let sorcererAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let r = "#622461"
        let p = "#93388f"
        let s = "#e4a672"
        let e = "#ffffff"
        let k = "#131313"
        let h = "#571c27"
        let b = "#391f21"
        let f = "#ea323c"  // fire
        let y = "#ffeb57"
        let fo = "#e07438" // fire orange
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, y, c, y, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, y, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, y, fo, y, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, f, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, y, c, y, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, p, p, p, p, p, p, o, c, c, c, c,
            c, c, c, o, r, p, p, p, p, p, p, r, o, s, o, c,
            c, c, c, c, o, o, p, p, p, p, o, s, o, c, c, c,
            c, c, c, c, c, o, r, p, p, r, o, c, c, c, c, c,
            c, c, c, c, c, o, r, r, r, r, o, c, c, c, c, c,
            c, c, c, c, c, o, r, r, r, r, o, c, c, c, c, c,
            c, c, c, c, o, r, o, o, o, o, r, o, c, c, c, c,
            c, c, c, o, b, b, o, c, c, o, b, b, o, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "sorcerer_attack", name: "Sorcerer — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Sorcerer", groupOrder: 2)
    }()
    
    // MARK: - Cleric (16x16)
    
    static let clericIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let w = "#ffffff"  // white robe
        let g = "#c0cbdc"  // robe shadow
        let d = "#92a1b9"  // robe dark
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let h = "#edab50"  // blonde hair
        let y = "#ffeb57"  // holy symbol
        let b = "#391f21"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, w, w, y, y, w, w, o, c, c, c, c,
            c, c, c, o, g, w, w, w, w, w, w, g, o, c, c, c,
            c, c, c, o, s, o, w, w, w, w, o, s, o, c, c, c,
            c, c, c, c, c, o, g, w, w, g, o, c, c, c, c, c,
            c, c, c, c, c, o, g, g, g, g, o, c, c, c, c, c,
            c, c, c, c, c, o, d, g, g, d, o, c, c, c, c, c,
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c,
            c, c, c, c, c, o, d, o, o, d, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "cleric_idle", name: "Cleric — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Cleric", groupOrder: 0)
    }()
    
    static let clericRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let w = "#ffffff"
        let g = "#c0cbdc"
        let d = "#92a1b9"
        let s = "#bf6f4a"
        let k = "#131313"
        let h = "#edab50"
        let y = "#ffeb57"
        let b = "#391f21"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, w, w, y, y, w, w, o, c, c, c, c,
            c, c, c, o, g, w, w, w, w, w, w, g, o, c, c, c,
            c, c, o, s, o, o, w, w, w, w, o, s, o, c, c, c,
            c, c, c, c, c, o, g, w, w, g, o, c, c, c, c, c,
            c, c, c, c, c, o, g, g, g, g, o, c, c, c, c, c,
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c,
            c, c, c, c, c, o, d, o, o, d, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "cleric_rest", name: "Cleric — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Cleric", groupOrder: 1)
    }()
    
    static let clericAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let w = "#ffffff"
        let g = "#c0cbdc"
        let d = "#92a1b9"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let h = "#edab50"
        let y = "#ffeb57"  // holy light
        let b = "#391f21"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, y, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, y, y, y, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, y, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, w, w, y, y, w, w, o, c, c, c, c,
            c, c, c, o, g, w, w, w, w, w, w, g, o, s, o, c,
            c, c, c, c, o, o, w, w, w, w, o, s, o, c, c, c,
            c, c, c, c, c, o, g, w, w, g, o, c, c, c, c, c,
            c, c, c, c, c, o, g, g, g, g, o, c, c, c, c, c,
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c,
            c, c, c, c, o, d, o, o, o, o, d, o, c, c, c, c,
            c, c, c, o, b, b, o, c, c, o, b, b, o, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "cleric_attack", name: "Cleric — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Cleric", groupOrder: 2)
    }()
    
    // MARK: - Priest (16x16)
    
    static let priestIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let w = "#f9e6cf"  // cream robe
        let g = "#f6ca9f"  // robe shadow
        let d = "#e4a672"  // robe dark
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let h = "#c0cbdc"  // silver hair
        let y = "#edab50"  // cross gold
        let b = "#391f21"
        let st = "#5d2c28" // staff
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, st, c, o, w, w, y, y, w, w, o, c, c, c, c,
            c, c, st, o, g, w, y, w, w, y, w, g, o, c, c, c,
            c, c, st, o, s, o, w, w, w, w, o, s, o, c, c, c,
            c, c, st, c, c, o, g, w, w, g, o, c, c, c, c, c,
            c, c, st, c, c, o, g, g, g, g, o, c, c, c, c, c,
            c, c, st, c, c, o, d, g, g, d, o, c, c, c, c, c,
            c, c, y, c, c, o, d, d, d, d, o, c, c, c, c, c,
            c, c, c, c, c, o, d, o, o, d, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "priest_idle", name: "Priest — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Priest", groupOrder: 0)
    }()
    
    static let priestRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let w = "#f9e6cf"
        let g = "#f6ca9f"
        let d = "#e4a672"
        let s = "#bf6f4a"
        let k = "#131313"
        let h = "#c0cbdc"
        let y = "#edab50"
        let b = "#391f21"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, w, w, y, y, w, w, o, c, c, c, c,
            c, c, c, o, g, w, y, w, w, y, w, g, o, c, c, c,
            c, c, o, s, o, o, w, w, w, w, o, s, o, c, c, c,
            c, c, c, c, c, o, g, w, w, g, o, c, c, c, c, c,
            c, c, c, c, c, o, d, g, g, d, o, c, c, c, c, c,
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c,
            c, c, c, c, c, o, d, o, o, d, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "priest_rest", name: "Priest — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Priest", groupOrder: 1)
    }()
    
    static let priestAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let w = "#f9e6cf"
        let g = "#f6ca9f"
        let d = "#e4a672"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let h = "#c0cbdc"
        let y = "#edab50"
        let b = "#391f21"
        let st = "#5d2c28"
        let hl = "#ffffff"  // holy light
        let hg = "#ffeb57"  // holy glow
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, hg, hl, hg, c,
            c, c, c, c, c, c, c, c, c, c, c, c, hl, hg, hl, c,
            c, c, c, c, c, o, o, o, o, o, o, c, hg, hl, hg, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, st, c, o, w, w, y, y, w, w, o, c, c, c, c,
            c, c, st, o, g, w, y, w, w, y, w, g, o, s, o, c,
            c, c, st, c, o, o, w, w, w, w, o, s, o, c, c, c,
            c, c, st, c, c, o, g, w, w, g, o, c, c, c, c, c,
            c, c, y, c, c, o, d, g, g, d, o, c, c, c, c, c,
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c,
            c, c, c, c, o, d, o, o, o, o, d, o, c, c, c, c,
            c, c, c, o, b, b, o, c, c, o, b, b, o, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "priest_attack", name: "Priest — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Priest", groupOrder: 2)
    }()
    
    // MARK: - Warrior (16x16)
    
    static let warriorIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#8a4836"  // brown leather
        let ad = "#5d2c28"
        let s = "#bf6f4a"
        let h = "#391f21"  // dark hair
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let g = "#edab50"  // belt buckle
        let sh = "#c0cbdc" // shield
        let sd = "#657392"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, sh, sd, o, a, a, g, g, a, a, o, c, c, c, c,
            c, c, sh, sh, ad, a, a, a, a, a, a, ad, o, c, c, c,
            c, c, sd, sh, s, o, a, a, a, a, o, s, o, c, c, c,
            c, c, sd, sd, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, ad, ad, ad, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, b, b, b, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "warrior_idle", name: "Warrior — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Warrior", groupOrder: 0)
    }()
    
    static let warriorRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#8a4836"
        let ad = "#5d2c28"
        let s = "#bf6f4a"
        let h = "#391f21"
        let k = "#131313"
        let b = "#391f21"
        let g = "#edab50"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, a, a, g, g, a, a, o, c, c, c, c,
            c, c, c, o, ad, a, a, a, a, a, a, ad, o, c, c, c,
            c, c, o, s, o, o, a, a, a, a, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, ad, ad, ad, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "warrior_rest", name: "Warrior — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Warrior", groupOrder: 1)
    }()
    
    static let warriorAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#8a4836"
        let ad = "#5d2c28"
        let s = "#bf6f4a"
        let h = "#391f21"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let g = "#edab50"
        let w = "#c0cbdc"  // sword
        let wd = "#657392"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, w, wd, c,
            c, c, c, c, c, c, c, c, c, c, c, c, w, wd, c, c,
            c, c, c, c, c, o, o, o, o, o, o, w, wd, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, g, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, a, a, g, g, a, a, o, c, c, c, c,
            c, c, c, o, ad, a, a, a, a, a, a, ad, s, o, c, c,
            c, c, c, c, o, o, a, a, a, a, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, b, b, b, o, c, c, c, c, c,
            c, c, c, c, o, b, o, o, o, b, o, c, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "warrior_attack", name: "Warrior — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Warrior", groupOrder: 2)
    }()
    
    // MARK: - Spearman (16x16)
    
    static let spearmanIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#0069aa"  // blue armor
        let ad = "#00396d"
        let s = "#bf6f4a"
        let h = "#5d2c28"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let sp = "#b86f50"  // spear shaft
        let st = "#c0cbdc"  // spear tip
        
        let grid: [String] = [
            c, c, c, st, st, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, sp, st, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, sp, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, sp, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, sp, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, sp, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, sp, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, sp, o, a, a, a, a, a, a, o, c, c, c, c,
            c, c, c, sp, ad, a, a, a, a, a, a, ad, o, c, c, c,
            c, c, c, c, s, o, a, a, a, a, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, ad, ad, ad, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "spearman_idle", name: "Spearman — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Spearman", groupOrder: 0)
    }()
    
    static let spearmanRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#0069aa"
        let ad = "#00396d"
        let s = "#bf6f4a"
        let h = "#5d2c28"
        let k = "#131313"
        let b = "#391f21"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, a, a, a, a, a, a, o, c, c, c, c,
            c, c, c, o, ad, a, a, a, a, a, a, ad, o, c, c, c,
            c, c, o, s, o, o, a, a, a, a, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, ad, ad, ad, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "spearman_rest", name: "Spearman — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Spearman", groupOrder: 1)
    }()
    
    static let spearmanAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#0069aa"
        let ad = "#00396d"
        let s = "#bf6f4a"
        let h = "#5d2c28"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let sp = "#b86f50"
        let st = "#c0cbdc"
        let sd = "#657392"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, st, st, sd, c,
            c, c, c, c, c, c, c, c, c, c, c, c, sp, sd, c, c,
            c, c, c, c, c, o, o, o, o, o, o, sp, sp, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, a, a, a, a, a, a, o, c, c, c, c,
            c, c, c, o, ad, a, a, a, a, a, a, ad, s, o, c, c,
            c, c, c, c, o, o, a, a, a, a, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, ad, ad, ad, ad, o, c, c, c, c, c,
            c, c, c, c, o, b, o, o, o, b, o, c, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "spearman_attack", name: "Spearman — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Spearman", groupOrder: 2)
    }()
    
    // MARK: - Assassin (16x16) — Bonus character
    
    static let assassinIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#2a2f4e"  // dark cloth
        let ad = "#1a1932"
        let s = "#bf6f4a"
        let h = "#131313"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#131313"
        let m = "#3d3d3d"  // mask
        let dg = "#657392" // dagger
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, m, e, k, m, e, k, o, c, c, c, c,
            c, c, c, c, c, o, m, m, m, m, o, c, c, c, c, c,
            c, c, c, c, o, a, a, a, a, a, a, o, c, c, c, c,
            c, c, c, o, ad, a, a, a, a, a, a, ad, o, c, c, c,
            c, c, c, o, s, o, a, a, a, a, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, dg, c, c, c, c,
            c, c, c, c, c, o, ad, ad, ad, ad, o, dg, c, c, c, c,
            c, c, c, c, c, o, b, b, b, b, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "assassin_idle", name: "Assassin — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Assassin", groupOrder: 0)
    }()
    
    static let assassinRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#2a2f4e"
        let ad = "#1a1932"
        let s = "#bf6f4a"
        let h = "#131313"
        let k = "#131313"
        let b = "#131313"
        let m = "#3d3d3d"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, m, k, k, m, k, k, o, c, c, c, c,
            c, c, c, c, c, o, m, m, m, m, o, c, c, c, c, c,
            c, c, c, c, o, a, a, a, a, a, a, o, c, c, c, c,
            c, c, c, o, ad, a, a, a, a, a, a, ad, o, c, c, c,
            c, c, o, s, o, o, a, a, a, a, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, ad, ad, ad, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "assassin_rest", name: "Assassin — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Assassin", groupOrder: 1)
    }()
    
    static let assassinAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#2a2f4e"
        let ad = "#1a1932"
        let s = "#bf6f4a"
        let h = "#131313"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#131313"
        let m = "#3d3d3d"
        let dg = "#c0cbdc"  // dagger blade
        let dd = "#657392"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, dg, dd, c, c,
            c, c, c, c, c, c, c, c, c, c, c, dg, dd, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, dd, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            c, c, c, c, o, m, e, k, m, e, k, o, c, c, c, c,
            c, c, c, c, c, o, m, m, m, m, o, c, c, c, c, c,
            c, c, c, c, o, a, a, a, a, a, a, o, c, c, c, c,
            c, c, c, o, ad, a, a, a, a, a, a, ad, s, o, c, c,
            c, c, c, c, o, o, a, a, a, a, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, b, b, b, o, c, c, c, c, c,
            c, c, c, c, o, b, o, o, o, b, o, c, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, o, b, b, o, c, c, c, o, b, b, o, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "assassin_attack", name: "Assassin — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Assassin", groupOrder: 2)
    }()
    
    // MARK: - Paladin (16x16) — Bonus character
    
    static let paladinIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#edab50"  // gold armor
        let ad = "#e07438"
        let w = "#ffffff"  // white tabard
        let s = "#bf6f4a"
        let h = "#edab50"  // blonde
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let cr = "#ea323c" // cross
        let hm = "#c0cbdc" // helmet
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, hm, hm, hm, hm, hm, hm, o, c, c, c, c,
            c, c, c, c, o, hm, ad, hm, hm, ad, hm, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, a, w, cr, cr, w, a, o, c, c, c, c,
            c, c, c, o, ad, a, cr, w, w, cr, a, ad, o, c, c, c,
            c, c, c, o, s, o, w, cr, cr, w, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, ad, ad, ad, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, b, b, b, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "paladin_idle", name: "Paladin — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Paladin", groupOrder: 0)
    }()
    
    static let paladinRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#edab50"
        let ad = "#e07438"
        let w = "#ffffff"
        let s = "#bf6f4a"
        let k = "#131313"
        let b = "#391f21"
        let cr = "#ea323c"
        let hm = "#c0cbdc"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, o, hm, hm, hm, hm, hm, hm, o, c, c, c, c,
            c, c, c, c, o, hm, ad, hm, hm, ad, hm, o, c, c, c, c,
            c, c, c, c, o, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, a, w, cr, cr, w, a, o, c, c, c, c,
            c, c, c, o, ad, a, cr, w, w, cr, a, ad, o, c, c, c,
            c, c, o, s, o, o, w, cr, cr, w, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, ad, ad, ad, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "paladin_rest", name: "Paladin — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Paladin", groupOrder: 1)
    }()
    
    static let paladinAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#edab50"
        let ad = "#e07438"
        let w = "#ffffff"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let cr = "#ea323c"
        let hm = "#c0cbdc"
        let sw = "#c0cbdc" // sword
        let sd = "#657392"
        let sg = "#edab50" // guard
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, sw, sd, c,
            c, c, c, c, c, c, c, c, c, c, c, c, sw, sd, c, c,
            c, c, c, c, c, o, o, o, o, o, o, sw, sd, c, c, c,
            c, c, c, c, o, hm, hm, hm, hm, hm, hm, sg, c, c, c, c,
            c, c, c, c, o, hm, ad, hm, hm, ad, hm, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, a, w, cr, cr, w, a, o, c, c, c, c,
            c, c, c, o, ad, a, cr, w, w, cr, a, ad, s, o, c, c,
            c, c, c, c, o, o, w, cr, cr, w, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, b, b, b, o, c, c, c, c, c,
            c, c, c, c, o, b, o, o, o, b, o, c, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "paladin_attack", name: "Paladin — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Paladin", groupOrder: 2)
    }()
    
    // MARK: - Ranger (16x16) — Bonus character
    
    static let rangerIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#1e6f50"  // forest green
        let ad = "#134c4c"
        let s = "#bf6f4a"
        let h = "#5d2c28"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let cl = "#33984b" // cloak
        let ht = "#8a4836" // hat
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, o, ht, ht, o, c, c, c, c, c, c,
            c, c, c, c, c, o, ht, ht, ht, ht, o, c, c, c, c, c,
            c, c, c, c, o, ht, ht, ht, ht, ht, ht, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, cl, a, a, a, a, cl, o, c, c, c, c,
            c, c, c, o, cl, a, a, a, a, a, a, cl, o, c, c, c,
            c, c, c, o, s, o, a, a, a, a, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, ad, ad, ad, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, b, b, b, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "ranger_idle", name: "Ranger — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Ranger", groupOrder: 0)
    }()
    
    static let rangerRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#1e6f50"
        let ad = "#134c4c"
        let s = "#bf6f4a"
        let h = "#5d2c28"
        let k = "#131313"
        let b = "#391f21"
        let cl = "#33984b"
        let ht = "#8a4836"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, o, ht, ht, o, c, c, c, c, c, c,
            c, c, c, c, c, o, ht, ht, ht, ht, o, c, c, c, c, c,
            c, c, c, c, o, ht, ht, ht, ht, ht, ht, o, c, c, c, c,
            c, c, c, c, o, s, k, k, s, k, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, cl, a, a, a, a, cl, o, c, c, c, c,
            c, c, c, o, cl, a, a, a, a, a, a, cl, o, c, c, c,
            c, c, o, s, o, o, a, a, a, a, o, s, o, c, c, c,
            c, c, c, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, ad, ad, ad, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, o, o, b, o, c, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "ranger_rest", name: "Ranger — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Ranger", groupOrder: 1)
    }()
    
    static let rangerAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#1e6f50"
        let ad = "#134c4c"
        let s = "#bf6f4a"
        let h = "#5d2c28"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let cl = "#33984b"
        let ht = "#8a4836"
        let bw = "#b86f50"  // bow
        let ar = "#c0cbdc"  // arrow
        let ard = "#657392"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, ar, ard, c,
            c, c, c, c, c, c, c, c, c, c, c, c, ar, ard, c, c,
            c, c, c, c, c, c, o, ht, ht, o, c, ar, ard, c, c, c,
            c, c, c, c, c, o, ht, ht, ht, ht, o, c, c, c, c, c,
            c, c, c, c, o, ht, ht, ht, ht, ht, ht, o, c, c, c, c,
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            c, c, c, c, o, cl, a, a, a, a, cl, o, c, c, c, c,
            c, c, bw, o, cl, a, a, a, a, a, a, cl, s, o, c, c,
            c, bw, o, c, o, o, a, a, a, a, o, s, o, c, c, c,
            c, c, bw, c, c, o, ad, a, a, ad, o, c, c, c, c, c,
            c, c, c, c, c, o, b, b, b, b, o, c, c, c, c, c,
            c, c, c, c, o, b, o, o, o, b, o, c, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, o, b, b, o, c, o, b, b, o, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "ranger_attack", name: "Ranger — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Ranger", groupOrder: 2)
    }()
}

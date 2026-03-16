//
//  PremadeSpritesCharacters1616.swift
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
        let o = "#0e071b"   // outline black
        let m = "#657392"   // chainmail / metal mid
        let l = "#c0cbdc"   // armor light / blade
        let d = "#424c6e"   // armor dark
        let v = "#0e071b"   // visor slit (black)
        let s = "#bf6f4a"   // skin
        let g = "#edab50"   // gold / pommel
        let n = "#0069aa"   // surcoat blue
        let r = "#ffffff"   // cross white / blade shine
        let b = "#391f21"   // brown leather
        let t = "#5d2c28"   // dark brown
        
        let grid: [String] = [
            c, c, c, c, c, o, o, o, o, o, c, c, c, c, c, c,
            c, c, c, c, o, m, l, l, l, m, o, c, c, c, c, c,
            c, c, c, c, o, l, l, l, l, l, o, c, c, c, c, c,
            c, c, c, c, o, d, v, v, v, d, o, c, c, c, c, c,
            c, c, c, c, o, d, d, v, d, d, o, c, c, c, c, c,
            c, c, c, c, o, m, m, d, m, m, o, c, c, c, c, c,
            c, c, c, c, c, o, m, m, m, o, c, c, c, c, c, c,
            c, c, c, o, d, m, n, n, n, m, d, o, c, c, c, c,
            c, c, c, o, m, n, n, r, n, n, m, o, c, c, c, c,
            c, c, o, d, o, n, r, r, r, n, o, d, o, c, c, c,
            c, o, d, s, o, n, n, r, n, n, o, s, l, o, c, c,
            c, o, n, d, c, o, n, n, n, o, c, c, l, o, c, c,
            c, o, d, o, c, o, m, c, m, o, c, c, l, o, c, c,
            c, c, c, c, c, o, d, c, d, o, c, c, d, c, c, c,
            c, c, c, c, o, b, b, c, b, b, o, c, g, c, c, c,
            c, c, c, c, o, o, o, c, o, o, o, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "knight_idle", name: "Knight — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Knight", groupOrder: 0)
    }()
    
    // MARK: - Knight Rest (16x16)
    
    static let knightRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let m = "#657392"
        let l = "#c0cbdc"
        let d = "#424c6e"
        let s = "#bf6f4a"
        let g = "#edab50"
        let n = "#0069aa"
        let r = "#ffffff"
        let b = "#391f21"
        let t = "#5d2c28"
        let k = "#131313"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, l, l, l, l, l, d, g, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, o, o, c, c, o, o, o, o, c, c,
            c, c, c, c, o, t, t, t, o, c, o, l, l, m, o, c,
            c, c, c, c, o, s, s, s, o, c, o, d, k, d, o, c,
            c, c, c, c, o, s, k, k, o, c, o, m, m, m, o, c,
            c, c, c, c, c, o, s, o, c, c, c, o, o, o, c, c,
            c, c, c, o, d, m, n, n, n, m, d, o, c, c, c, c,
            c, c, o, m, n, n, n, r, n, n, n, m, o, c, c, c,
            c, c, o, s, o, n, r, r, r, n, o, s, o, c, c, c,
            c, c, c, c, o, m, d, d, d, m, o, c, c, c, c, c,
            c, c, c, c, o, b, b, b, b, b, o, c, c, c, c, c,
            c, c, c, c, c, o, o, o, o, o, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "knight_rest", name: "Knight — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Knight", groupOrder: 1)
    }()
    
    // MARK: - Knight Attack (16x16)
    
    static let knightAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let m = "#657392"
        let l = "#c0cbdc"
        let d = "#424c6e"
        let s = "#bf6f4a"
        let g = "#edab50"
        let n = "#0069aa"
        let r = "#ffffff"
        let b = "#391f21"
        let t = "#5d2c28"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, r, l, l, l, c,
            c, c, c, c, c, c, c, c, c, c, r, l, d, c, c, c,
            c, c, c, c, c, c, c, c, c, g, g, g, c, c, c, c,
            c, c, c, c, c, c, o, o, o, o, o, c, c, c, c, c,
            c, c, c, c, c, o, m, l, l, l, m, o, c, c, c, c,
            c, c, c, c, c, o, l, l, l, l, l, o, c, c, c, c,
            c, c, c, c, c, o, d, o, o, o, d, o, c, c, c, c,
            c, c, c, c, c, o, d, d, o, d, d, o, c, c, c, c,
            c, c, c, c, c, c, o, m, m, m, o, c, c, c, c, c,
            c, o, d, o, c, o, m, n, n, n, m, o, s, o, c, c,
            c, o, n, d, o, m, n, r, n, n, m, s, c, c, c, c,
            c, o, d, o, c, o, n, n, n, n, o, c, c, c, c, c,
            c, c, c, c, c, o, m, d, m, o, c, c, c, c, c, c,
            c, c, c, c, o, d, d, c, c, d, d, o, c, c, c, c,
            c, c, c, o, b, b, o, c, c, c, o, b, o, c, c, c,
            c, c, c, o, o, o, c, c, c, c, o, o, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "knight_attack", name: "Knight — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Knight", groupOrder: 2)
    }()
}

//
//  PremadeSpritesCharacters3232.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-17.
//

import Foundation

extension PremadeSprites {
    
    // MARK: - Knight Idle (32x32)
    
    static let knightIdle32: PremadeSpriteData = {
        let c = "clear"
        let o = "#111111"
        let gr = "#5D5D5D"
        let m = "#606E92"
        let cm = "#637192"
        let b = "#8A4536"
        let l = "#92A1B9"
        let r = "#C41F2C"
        let h = "#C7CFDD"
        let p = "#FF0040"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, cm, h, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, cm, cm, cm, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, cm, cm, cm, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, r, r, r, r, r, r, p, c, cm, cm, cm, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, r, r, r, r, r, r, r, p, p, cm, cm, cm, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, r, r, r, r, r, r, r, r, p, p, cm, cm, cm, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, r, r, m, m, m, m, m, r, p, p, cm, cm, cm, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, r, m, m, m, m, m, m, l, p, p, h, cm, cm, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, m, m, m, m, m, m, l, l, l, h, l, cm, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, m, m, m, m, m, m, l, l, l, h, cm, l, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, m, m, m, m, m, o, o, l, l, o, l, cm, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, m, m, m, m, m, o, o, o, o, o, l, l, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, b, b, b, b, b, b, l, l, l, o, o, h, cm, l, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, b, b, l, l, b, b, l, l, l, o, o, h, cm, cm, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, b, l, l, l, l, b, l, l, l, o, o, h, cm, cm, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, b, l, l, l, l, b, l, m, m, m, m, m, o, o, o, gr, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, b, b, l, l, b, b, l, l, l, l, l, h, m, l, o, gr, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, b, b, l, l, b, b, l, m, m, m, m, m, m, l, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, b, b, b, b, l, m, l, l, l, l, h, o, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, b, b, l, m, m, l, l, l, l, h, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, m, m, m, c, c, m, m, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, m, m, c, c, c, m, m, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, h, h, c, c, c, m, m, l, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "knight_idle_32", name: "Knight — Idle", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Knight", groupOrder: 0)
    }()
    
    // MARK: - Knight Attack (32x32)
    
    static let knightAttack32: PremadeSpriteData = {
        let c = "clear"
        let o = "#111111"
        let gr = "#5D5D5D"
        let m = "#606E92"
        let cm = "#637192"
        let b = "#8A4536"
        let l = "#92A1B9"
        let r = "#C41F2C"
        let h = "#C7CFDD"
        let p = "#FF0040"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, r, r, r, r, r, r, p, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, r, r, r, r, r, r, r, p, p, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, r, r, r, r, r, r, r, r, p, p, c, h, h, h, h, h, h, h, h, h, c, c, c, c, c, c, c, c,
            c, c, c, c, r, r, m, m, m, m, m, r, p, p, c, c, c, c, h, h, h, h, h, h, h, h, c, c, c, c, c, c,
            c, c, c, c, r, m, m, m, m, m, m, l, p, p, h, c, c, c, c, c, h, h, h, h, h, h, h, c, c, c, c, c,
            c, c, c, c, c, m, m, m, m, m, m, l, l, l, h, c, c, c, c, c, c, h, h, h, h, h, h, h, c, c, c, c,
            c, c, c, c, c, m, m, m, m, m, m, l, l, l, h, c, c, c, c, c, c, c, cm, h, h, h, h, h, h, c, c, c,
            c, c, c, c, c, m, m, m, m, m, o, o, l, l, o, c, c, c, c, c, c, c, cm, cm, h, h, h, h, h, c, c, c,
            c, c, c, c, c, m, m, m, m, m, o, o, o, o, o, c, c, c, c, c, c, c, cm, cm, cm, h, h, h, h, h, c, c,
            c, b, b, b, b, b, b, l, m, m, l, l, o, o, h, c, c, c, c, c, c, c, c, cm, cm, h, h, h, h, h, c, c,
            c, b, b, m, m, b, b, l, m, m, l, l, o, o, h, c, c, c, c, c, c, c, c, cm, cm, cm, h, h, h, h, c, c,
            c, b, m, m, m, m, b, l, m, m, l, l, o, o, h, c, c, c, c, c, c, c, c, cm, cm, cm, h, h, h, h, h, c,
            c, b, m, m, m, m, b, l, m, m, m, m, m, m, m, c, c, c, c, c, c, c, cm, cm, cm, cm, h, h, h, h, h, c,
            c, b, b, m, m, b, b, l, m, m, l, l, l, l, h, c, c, c, c, c, c, cm, cm, cm, cm, cm, h, h, h, h, h, c,
            c, b, b, m, m, b, b, l, m, m, m, m, m, m, m, c, c, c, c, c, cm, cm, cm, cm, cm, cm, h, h, h, h, h, c,
            c, c, b, b, b, b, l, m, m, m, l, l, l, l, h, c, o, o, gr, cm, cm, cm, cm, cm, cm, cm, h, h, h, h, c, c,
            c, c, c, b, b, l, c, m, m, m, l, l, l, l, h, l, l, o, cm, cm, cm, cm, cm, cm, cm, h, h, h, h, h, c, c,
            c, c, c, c, c, c, c, m, m, m, c, c, m, m, c, m, m, o, cm, cm, cm, cm, cm, cm, h, h, h, h, h, c, c, c,
            c, c, c, c, c, c, c, m, m, c, c, c, m, m, c, c, c, o, cm, cm, cm, cm, cm, h, h, h, h, h, c, c, c, c,
            c, c, c, c, c, c, c, l, l, c, c, c, m, m, l, c, o, o, gr, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "knight_attack_32", name: "Knight — Attack", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Knight", groupOrder: 1)
    }()
    
    // MARK: - Knight Run (32x32)
    
    static let knightRun32: PremadeSpriteData = {
        let c = "clear"
        let o = "#111111"
        let gr = "#5D5D5D"
        let m = "#606E92"
        let cm = "#647292"
        let b = "#8A4536"
        let b2 = "#8A4736"
        let l = "#92A1B9"
        let r = "#C41F2C"
        let h = "#C7CFDD"
        let p = "#FF0040"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, m, h, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, m, m, m, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, m, m, m, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, r, r, r, r, r, r, p, c, m, m, m, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, r, r, r, r, r, r, r, p, p, m, m, m, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, r, r, r, r, r, r, r, r, p, p, m, m, m, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, r, r, m, m, m, m, m, r, p, p, m, m, m, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, r, m, m, m, m, m, m, l, p, p, h, m, m, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, m, m, m, m, m, m, l, l, l, h, l, m, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, m, m, m, m, m, m, l, l, l, h, m, l, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, m, m, m, m, m, o, o, l, l, o, l, m, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, m, m, m, m, m, o, o, o, o, o, l, l, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, cm, cm, cm, cm, cm, l, l, o, o, h, m, l, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, b, b, b2, b2, b, b, l, l, l, o, o, h, m, m, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, b, b2, l, l, b2, b, l, l, l, o, o, h, m, m, h, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, b, l, l, l, l, b, l, m, m, m, m, m, o, o, o, gr, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, b, b, l, l, b, b, l, l, l, l, l, h, m, l, o, gr, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, b, b, l, l, b, b, l, m, m, m, m, m, m, l, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, b2, b, l, l, b, b2, l, l, l, l, l, h, o, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, b2, b, b, b2, l, l, l, l, l, l, h, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, b2, b2, l, c, c, c, c, c, cm, cm, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, cm, cm, c, c, c, c, c, c, cm, cm, l, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, cm, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "knight_run_32", name: "Knight — Run", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Knight", groupOrder: 2)
    }()
}

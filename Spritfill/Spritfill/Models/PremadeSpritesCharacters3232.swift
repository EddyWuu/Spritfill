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
    
    // MARK: - Archer Idle (32x32)
    
    static let archerIdle32: PremadeSpriteData = {
        let c = "clear"
        let dn = "#0B2D44"
        let o = "#121212"
        let dt = "#124B4B"
        let dg = "#1E6E50"
        let mg = "#32984A"
        let db = "#381F20"
        let lg = "#59C54F"
        let rb = "#5D2C28"
        let gr = "#848484"
        let sk = "#BF6E49"
        let ls = "#E69C68"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, rb, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, db, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, lg, lg, lg, lg, lg, db, rb, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, lg, mg, mg, mg, mg, db, rb, rb, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, lg, mg, mg, dg, dg, db, db, dg, dg, lg, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, lg, mg, dg, mg, db, mg, mg, mg, mg, db, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, lg, dg, dg, mg, mg, mg, mg, sk, sk, db, db, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, lg, lg, dg, dg, mg, mg, sk, sk, sk, sk, sk, db, rb, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, sk, o, o, sk, sk, o, o, sk, rb, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, ls, o, o, ls, ls, o, o, ls, ls, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, ls, ls, ls, ls, ls, ls, ls, ls, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, ls, ls, ls, ls, ls, ls, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, lg, lg, lg, lg, lg, lg, lg, lg, lg, lg, lg, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, dn, dt, dt, dt, dt, lg, lg, lg, lg, lg, lg, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, dn, dn, o, o, o, dt, dt, lg, lg, lg, lg, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, ls, ls, dg, dg, dg, o, o, dt, dt, dt, lg, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, db, gr, gr, gr, ls, ls, dg, dg, dg, dg, dg, o, dg, dt, dt, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, db, c, c, c, ls, ls, db, db, db, db, db, db, ls, ls, dt, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, db, db, c, c, lg, lg, db, db, db, db, db, db, lg, lg, dt, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, db, db, c, lg, mg, dt, dt, dt, c, dt, dt, lg, mg, dt, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, db, db, db, db, dt, dt, dt, db, dt, dt, dt, c, dt, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, dt, dt, dt, c, dt, dt, dt, c, dt, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, db, db, db, c, db, db, db, c, dt, dt, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, db, db, db, c, db, db, db, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "archer_idle_32", name: "Archer — Idle", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Archer", groupOrder: 0)
    }()
    
    // MARK: - Archer Attack (32x32)
    
    static let archerAttack32: PremadeSpriteData = {
        let c = "clear"
        let dn = "#0B2D44"
        let o = "#121212"
        let dt = "#124B4B"
        let dg = "#1E6E50"
        let mg = "#32984A"
        let db = "#381F20"
        let lg = "#59C54F"
        let rb = "#5D2C28"
        let gr = "#848484"
        let br = "#8A4736"
        let sk = "#BF6E49"
        let ls = "#E69C68"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, rb, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, db, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, lg, lg, lg, lg, lg, db, rb, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, lg, mg, mg, mg, mg, db, rb, rb, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, lg, mg, mg, dg, dg, db, db, dg, dg, lg, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, lg, mg, dg, mg, db, mg, mg, mg, mg, db, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, lg, dg, dg, mg, mg, mg, mg, sk, sk, db, db, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, lg, lg, dg, dg, mg, mg, sk, sk, sk, br, br, db, rb, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, db, db, sk, o, o, sk, sk, br, br, br, rb, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, db, db, c, gr, o, o, ls, ls, br, br, ls, br, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, db, db, c, c, ls, gr, ls, ls, ls, br, br, ls, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, db, c, c, c, c, ls, gr, ls, ls, ls, br, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, db, c, c, lg, lg, lg, lg, gr, lg, lg, lg, lg, lg, lg, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, db, c, c, dn, dt, dt, dt, dt, gr, lg, lg, lg, lg, lg, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, o, br, br, br, br, br, br, br, br, br, br, ls, ls, lg, lg, lg, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, mg, lg, ls, ls, ls, ls, dg, dg, mg, gr, ls, ls, ls, ls, lg, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, db, c, c, c, c, dg, dg, dg, gr, dg, ls, ls, ls, dt, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, db, c, c, c, c, db, db, gr, db, db, db, db, c, dt, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, db, c, c, c, c, db, gr, db, db, db, db, db, c, dt, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, db, db, c, c, c, gr, dt, dt, c, dt, dt, dt, c, dt, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, db, db, c, gr, dt, dt, dt, c, dt, dt, dt, c, dt, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, db, db, dt, dt, dt, c, c, c, dt, dt, dt, dt, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, db, db, db, c, c, c, db, db, db, dt, dt, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, db, db, db, c, c, c, c, c, db, db, db, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "archer_attack_32", name: "Archer — Attack", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Archer", groupOrder: 1)
    }()
    
    // MARK: - Archer Run (32x32)
    
    static let archerRun32: PremadeSpriteData = {
        let c = "clear"
        let dn = "#0B2D44"
        let o = "#121212"
        let dt = "#124B4B"
        let dg = "#1E6E50"
        let mg = "#32984A"
        let db = "#381F20"
        let lg = "#59C54F"
        let rb = "#5D2C28"
        let gr = "#848484"
        let br = "#8A4736"
        let sk = "#BF6E49"
        let ls = "#E69C68"
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, rb, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, db, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, lg, lg, lg, lg, lg, db, rb, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, lg, mg, mg, mg, mg, db, rb, rb, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, lg, mg, mg, dg, dg, db, db, dg, dg, lg, lg, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, lg, mg, dg, mg, db, mg, mg, mg, mg, db, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, lg, dg, dg, mg, mg, mg, mg, sk, sk, db, db, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, lg, lg, dg, dg, mg, mg, sk, sk, sk, br, sk, db, rb, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, sk, o, o, sk, sk, br, br, br, rb, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, db, c, c, c, c, ls, o, o, ls, ls, br, br, ls, br, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, db, c, gr, c, c, c, ls, ls, ls, ls, ls, br, ls, ls, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, db, c, c, gr, c, c, c, ls, ls, ls, ls, ls, br, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, db, c, c, c, gr, lg, lg, lg, lg, lg, lg, lg, lg, lg, lg, lg, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, db, c, c, c, c, dn, dn, dt, dt, dt, dt, lg, lg, lg, lg, lg, lg, lg, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, db, c, c, br, br, br, dt, o, o, o, dg, dg, lg, lg, lg, lg, lg, lg, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, db, mg, mg, ls, ls, mg, mg, mg, mg, o, o, dg, ls, ls, c, lg, lg, lg, lg, c, c, c, c, c, c,
            c, c, c, c, c, c, c, lg, lg, lg, c, c, dg, dg, dg, dg, dg, dg, dg, ls, ls, lg, c, c, dg, dg, dg, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, db, c, c, db, db, db, db, db, db, db, c, lg, lg, lg, c, c, dg, dg, dg, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, db, db, db, db, db, db, db, db, db, c, c, mg, mg, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, dt, dt, dt, c, c, dt, dt, dt, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, dt, dt, dt, c, c, c, c, dt, dt, dt, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, db, db, dt, dt, c, c, c, c, c, c, dt, dt, db, db, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, db, db, db, c, c, c, c, c, c, c, c, db, db, db, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "archer_run_32", name: "Archer — Run", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Archer", groupOrder: 2)
    }()
}

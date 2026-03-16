//
//  PremadeSprites.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import Foundation

// MARK: - All 32x32 Non-Character Sprites (Landscapes)

extension PremadeSprites {

    // MARK: - Mountain Range
    
    static let mountainRange: PremadeSpriteData = {
        let c = "clear"
        let sk = "#94fdff"
        let sb = "#00cdf9"
        let sd = "#0099db"
        let sn = "#ffffff"
        let sg = "#c0cbdc"
        let r = "#657392"
        let rd = "#424c6e"
        let g = "#33984b"
        let gd = "#1e6f50"
        let gl = "#5ac54f"
        let t = "#5d2c28"
        let e = "#e4a672"
        
        let w = 32
        let grid: [String] = [
      
            sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb,
            sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb,
            sk, sk, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sk, sk,
            sk, sk, sk, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sk, sk, sk,
         
            sk, sk, sk, sb, sb, sb, sb, sb, sb, sb, sb, sb, sn, sn, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sk, sk, sk, sk,
            sk, sk, sk, sk, sb, sb, sb, sb, sb, sb, sb, sn, sn, sn, sn, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sk, sk, sk, sk, sk,
            sk, sk, sk, sk, sb, sb, sb, sb, sb, sb, sn, sn, sg, sn, sn, sn, sb, sb, sb, sb, sb, sb, sb, sb, sn, sb, sb, sb, sk, sk, sk, sk,
            sk, sk, sk, sk, sb, sb, sb, sb, sb, sn, sn, sg, sg, sg, sn, sn, sb, sb, sb, sb, sb, sb, sb, sn, sn, sn, sb, sb, sb, sk, sk, sk,
   
            sk, sk, sk, sk, sb, sb, sb, sb, r, sn, sg, sg, r, sg, sg, sn, sn, sb, sb, sb, sb, sb, sn, sn, sg, sn, sn, sb, sb, sb, sk, sk,
            sk, sk, sk, sk, sb, sb, sb, r, r, r, sg, r, r, r, sg, sg, sn, sn, sb, sb, sb, sn, sn, sg, sg, sg, sn, sn, sb, sb, sk, sk,
            sk, sk, sk, sk, sb, sb, r, r, rd, r, r, r, rd, r, r, sg, sg, sn, sb, sb, sn, sn, sg, sg, r, sg, sg, sn, sb, sb, sk, sk,
            sk, sk, sk, sb, sb, r, r, rd, rd, rd, r, r, rd, rd, r, r, sg, sn, sn, sn, sn, sg, sg, r, r, r, sg, sn, sn, sb, sk, sk,
    
            sk, sk, sb, sb, r, r, rd, rd, rd, rd, r, r, rd, rd, rd, r, r, r, r, r, r, r, r, r, rd, r, r, sg, sn, sb, sb, sk,
            sk, sb, sb, r, r, rd, rd, rd, rd, rd, r, r, rd, rd, rd, rd, r, r, r, r, r, r, rd, rd, rd, rd, r, r, r, sb, sb, sk,
            sb, sb, r, r, rd, rd, rd, rd, rd, rd, rd, r, r, rd, rd, rd, rd, r, r, r, r, rd, rd, rd, rd, rd, rd, r, r, r, sb, sb,
            sb, r, r, rd, rd, rd, rd, rd, rd, rd, rd, rd, r, r, rd, rd, rd, rd, r, r, rd, rd, rd, rd, rd, rd, rd, rd, r, r, r, sb,
     
            r, r, rd, rd, rd, gd, g, gd, rd, rd, rd, rd, rd, r, rd, rd, rd, gd, g, gd, rd, rd, rd, rd, rd, rd, gd, g, gd, rd, r, r,
            gd, rd, rd, gd, g, g, gl, g, gd, rd, rd, rd, gd, g, gd, rd, gd, g, gl, g, gd, rd, rd, rd, gd, g, g, gl, g, gd, rd, rd,
            gd, gd, gd, g, g, gl, gl, gl, g, gd, rd, gd, g, gl, g, gd, g, gl, gl, gl, g, gd, rd, gd, g, gl, gl, gl, gl, g, gd, gd,
            g, gd, g, g, gl, gl, t, gl, gl, g, gd, g, gl, gl, gl, g, gl, gl, t, gl, gl, g, gd, g, gl, gl, gl, t, gl, gl, g, gd,
         
            g, g, gl, gl, gl, t, t, t, gl, gl, g, gl, gl, t, gl, gl, gl, t, t, t, gl, gl, g, gl, gl, t, t, t, t, gl, gl, g,
            g, g, gl, gl, t, t, t, t, t, gl, g, gl, t, t, t, gl, gl, t, t, t, t, gl, g, gl, t, t, t, t, t, gl, g, g,
            gd, g, g, t, t, t, t, t, t, t, g, g, t, t, t, g, g, t, t, t, t, t, g, g, t, t, t, t, t, t, g, gd,
            gd, gd, g, g, t, g, g, g, t, g, gd, g, g, t, g, gd, g, g, t, g, g, g, gd, g, g, t, g, g, t, g, gd, gd,
          
            g, gd, g, g, g, g, gl, g, g, g, g, gd, g, g, g, g, g, g, g, g, gl, g, g, g, g, g, g, g, g, g, gd, g,
            g, g, gl, g, g, gl, gl, gl, g, g, g, g, gl, g, g, g, g, gl, g, gl, gl, gl, g, g, g, g, gl, g, g, g, g, g,
            gd, g, g, gl, gl, g, g, g, gl, g, gd, g, g, gl, g, gd, g, g, gl, g, g, g, gd, g, g, gl, gl, g, g, gl, g, gd,
            e, gd, g, g, g, g, g, g, g, gd, e, gd, g, g, gd, e, gd, g, g, g, g, g, e, gd, g, g, g, g, g, g, gd, e,
         
            e, e, gd, gd, g, g, g, g, gd, e, e, e, gd, gd, e, e, e, gd, gd, g, g, gd, e, e, gd, gd, g, g, gd, gd, e, e,
            e, e, e, e, gd, gd, gd, gd, e, e, e, e, e, e, e, e, e, e, e, gd, gd, e, e, e, e, e, gd, gd, e, e, e, e,
            e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e,
            e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e,
        ]
        
        return PremadeSpriteData(id: "mountain_range", name: "Mountain Range", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Landscapes", groupOrder: 0)
    }()
    
    // MARK: - Forest
    
    static let forest: PremadeSpriteData = {
        let c = "clear"
        let sk = "#94fdff"
        let sb = "#00cdf9"
        let g = "#33984b"
        let gd = "#1e6f50"
        let gl = "#5ac54f"
        let gx = "#99e65f"
        let t = "#5d2c28"
        let td = "#391f21"
        let e = "#8a4836"
        let ed = "#5d2c28"
        let fl = "#ffeb57"
        let fr = "#ea323c"
        
        let grid: [String] = [
      
            sk, sk, sk, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sk, sk, sk,
            sk, sk, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sk, sk,
            sk, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sk,
            sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb,
          
            sb, sb, sb, sb, sb, sb, sb, gd, g, sb, sb, sb, sb, sb, sb, gd, g, sb, sb, sb, sb, sb, gd, g, sb, sb, sb, sb, sb, sb, sb, sb,
            sb, sb, sb, sb, sb, sb, gd, g, gl, gd, sb, sb, sb, sb, gd, g, gl, gd, sb, sb, sb, gd, g, gl, gd, sb, sb, sb, sb, sb, sb, sb,
            sb, sb, sb, sb, sb, gd, g, gl, gx, g, gd, sb, sb, gd, g, gl, gx, g, gd, sb, gd, g, gl, gx, g, gd, sb, sb, sb, sb, sb, sb,
            sb, sb, sb, sb, gd, g, gl, gx, gx, gl, g, gd, gd, g, gl, gx, gx, gl, g, gd, g, gl, gx, gx, gl, g, gd, sb, sb, sb, sb, sb,
        
            sb, sb, sb, gd, g, gl, gx, gx, gx, gx, gl, g, g, gl, gx, gx, gx, gx, gl, g, gl, gx, gx, gx, gx, gl, g, gd, sb, sb, sb, sb,
            sb, sb, gd, g, gl, gx, gx, gx, gx, gx, gx, gl, gl, gx, gx, gx, gx, gx, gx, gl, gx, gx, gx, gx, gx, gx, gl, g, gd, sb, sb, sb,
            sb, gd, g, gl, gx, gx, gx, gl, gx, gx, gx, gx, gx, gx, gl, gx, gx, gx, gx, gx, gx, gl, gx, gx, gx, gx, gx, gl, g, gd, sb, sb,
            gd, g, gl, gx, gx, gx, gl, g, gl, gx, gx, gx, gx, gl, g, gl, gx, gx, gx, gx, gl, g, gl, gx, gx, gx, gx, gx, gl, g, gd, sb,
         
            g, gl, gx, gx, gx, gl, g, t, g, gl, gx, gx, gl, g, gd, g, gl, gx, gx, gl, g, gd, g, gl, gx, gx, gx, gl, gx, gl, g, gd,
            gd, g, gl, gx, gl, g, t, t, t, g, gl, gl, g, gd, gd, gd, g, gl, gl, g, gd, gd, gd, g, gl, gx, gl, g, gl, g, gd, gd,
            gd, gd, g, gl, g, t, t, t, t, t, g, g, gd, gd, gd, gd, gd, g, g, gd, gd, gd, gd, gd, g, gl, g, gd, g, gd, gd, gd,
            gd, gd, gd, g, g, g, t, t, t, g, g, gd, gd, gd, gd, gd, gd, gd, gd, gd, gd, gd, gd, gd, gd, g, gd, gd, gd, gd, gd, gd,
         
            gd, gd, g, g, gd, g, t, t, t, g, gd, gd, g, gd, g, gd, g, gd, gd, g, gd, gd, gd, g, gl, g, g, gd, gd, gd, gd, gd,
            g, gd, g, gl, g, t, t, t, t, t, g, gd, g, gl, g, gd, g, gl, g, gl, g, gd, g, gl, gl, gl, g, gd, gd, g, gd, gd,
            g, g, gl, gl, t, t, t, td, t, t, t, g, gl, gl, g, g, gl, gl, gl, gl, g, g, gl, gl, gx, gl, gl, g, g, gl, g, gd,
            gl, gl, gx, t, t, td, td, td, td, t, t, gl, gx, gl, gl, gl, gx, gx, gx, gl, gl, gl, gx, gx, gx, gx, gx, gl, gl, gl, gl, g,
    
            gx, gx, gl, g, t, td, g, td, t, g, gl, gx, gx, gx, gx, gx, gx, gx, gx, gx, gx, gx, gx, gx, gx, gx, gx, gx, gx, gx, gl, gl,
            gl, gl, g, g, t, g, g, g, t, g, g, gl, gx, gx, gx, gl, gl, gx, gx, gx, gl, gl, gx, gx, gx, gx, gl, gx, gx, gl, g, g,
            g, g, gd, g, t, g, gd, g, t, g, gd, g, gl, gl, g, g, g, gl, gl, g, g, g, g, gl, gl, g, g, g, gl, g, gd, gd,
            gd, gd, gd, g, t, gd, gd, gd, t, gd, gd, g, g, g, gd, gd, g, g, g, gd, gd, gd, g, g, g, gd, gd, gd, g, gd, gd, gd,
         
            g, g, gl, gl, g, g, fl, g, g, gl, g, g, gl, g, g, g, g, gl, fr, g, g, g, gl, g, g, gl, fl, g, g, g, g, g,
            gd, g, g, gl, gl, g, g, g, gl, gl, gd, g, g, gl, gd, gd, g, g, g, gl, gd, g, g, gl, gl, g, g, g, gl, gd, gd, gd,
            e, gd, g, g, g, gd, gd, gd, g, g, e, gd, g, g, gd, e, gd, g, gd, g, e, gd, g, g, g, gd, gd, gd, g, gd, e, e,
            e, e, gd, gd, gd, e, e, e, gd, gd, e, e, gd, gd, e, e, e, gd, e, gd, e, e, gd, gd, gd, e, e, e, gd, e, e, e,
           
            e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e,
            e, e, e, ed, e, e, e, e, ed, e, e, e, e, e, ed, e, e, e, ed, e, e, e, e, ed, e, e, e, e, e, ed, e, e,
            e, ed, ed, ed, e, e, ed, ed, ed, e, e, ed, e, ed, ed, e, ed, ed, ed, ed, e, e, ed, ed, ed, e, e, ed, ed, ed, e, e,
            ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed, ed,
        ]
        
        return PremadeSpriteData(id: "forest", name: "Forest", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Landscapes", groupOrder: 1)
    }()
    
    // MARK: - Sunset
    
    static let sunset: PremadeSpriteData = {
        let c = "clear"
        let s1 = "#571c27"
        let s2 = "#891e2b"
        let s3 = "#ea323c"
        let s4 = "#e07438"
        let s5 = "#edab50"
        let s6 = "#ffeb57"
        let sn = "#ffc825"
        let sw = "#ffffff"
        let wt = "#0c2e44"
        let wm = "#00396d"
        let wl = "#0069aa"
        let wr = "#e07438"
        let wy = "#edab50"
        
        let grid: [String] = [
           
            s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1,
            s1, s1, s1, s1, s1, s1, s2, s2, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s2, s2, s1, s1, s1, s1, s1, s1,
            s1, s1, s2, s2, s2, s2, s2, s2, s2, s2, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s1, s2, s2, s2, s2, s2, s2, s2, s1, s1, s1,
            s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s1, s1, s1, s1, s1, s1, s1, s1, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2,
          
            s2, s2, s2, s2, s2, s2, s3, s3, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s3, s3, s2, s2, s2, s2, s2, s2,
            s2, s3, s3, s3, s3, s3, s3, s3, s3, s3, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s2, s3, s3, s3, s3, s3, s3, s3, s3, s3, s2, s2,
            s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s2, s2, s2, s2, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3,
            s3, s3, s3, s4, s4, s4, s4, s4, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s3, s4, s4, s4, s4, s4, s3, s3, s3, s3,
           
            s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4, s4,
            s4, s4, s4, s4, s5, s5, s5, s5, s5, s4, s4, s4, s4, s5, s5, s5, s5, s5, s5, s4, s4, s4, s5, s5, s5, s5, s5, s4, s4, s4, s4, s4,
            s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5,
            s5, s5, s5, s5, s5, s6, s6, s6, s5, s5, s5, s5, s5, s6, sn, sn, sn, sn, s6, s5, s5, s5, s5, s6, s6, s6, s5, s5, s5, s5, s5, s5,
            
            s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, sn, sn, sw, sw, sw, sw, sn, sn, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6,
            s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, sn, sn, sw, sw, sw, sw, sn, sn, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6,
            s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, sn, sn, sn, sn, sn, sn, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6, s6,
            s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, sn, sn, sn, sn, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5, s5,
            
            wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wy, wy, wy, wy, wy, wy, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl,
            wl, wl, wm, wl, wl, wl, wl, wl, wl, wl, wl, wl, wy, wr, wy, wy, wy, wy, wr, wy, wl, wl, wl, wl, wl, wl, wl, wl, wm, wl, wl, wl,
            wm, wl, wl, wl, wl, wm, wl, wl, wl, wl, wl, wy, wr, wr, wr, wy, wy, wr, wr, wr, wy, wl, wl, wl, wl, wl, wm, wl, wl, wl, wl, wm,
            wm, wm, wl, wl, wl, wl, wl, wm, wl, wl, wl, wl, wy, wr, wy, wl, wl, wy, wr, wy, wl, wl, wl, wl, wm, wl, wl, wl, wl, wl, wm, wm,
            
            wm, wm, wl, wl, wl, wl, wl, wl, wl, wm, wl, wl, wl, wy, wl, wl, wl, wl, wy, wl, wl, wl, wm, wl, wl, wl, wl, wl, wl, wl, wm, wm,
            wm, wm, wm, wl, wl, wl, wm, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wm, wl, wl, wl, wm, wm, wm,
            wt, wm, wm, wl, wl, wl, wl, wl, wl, wl, wm, wl, wl, wl, wl, wm, wm, wl, wl, wl, wl, wm, wl, wl, wl, wl, wl, wl, wm, wm, wm, wt,
            wt, wm, wm, wm, wl, wl, wl, wl, wm, wl, wl, wl, wl, wl, wm, wm, wm, wm, wl, wl, wl, wl, wl, wm, wl, wl, wl, wm, wm, wm, wm, wt,
            
            wt, wt, wm, wm, wm, wl, wl, wl, wl, wl, wl, wm, wl, wl, wl, wm, wm, wl, wl, wl, wm, wl, wl, wl, wl, wl, wm, wm, wm, wm, wt, wt,
            wt, wt, wm, wm, wm, wm, wl, wl, wm, wl, wl, wl, wl, wm, wm, wm, wm, wm, wm, wl, wl, wl, wl, wm, wl, wm, wm, wm, wm, wt, wt, wt,
            wt, wt, wt, wm, wm, wm, wm, wm, wm, wm, wl, wl, wm, wm, wm, wt, wt, wm, wm, wm, wl, wl, wm, wm, wm, wm, wm, wm, wt, wt, wt, wt,
            wt, wt, wt, wt, wm, wm, wm, wm, wm, wm, wm, wm, wm, wm, wt, wt, wt, wt, wm, wm, wm, wm, wm, wm, wm, wm, wm, wt, wt, wt, wt, wt,
            
            wt, wt, wt, wt, wt, wm, wm, wm, wm, wm, wm, wm, wm, wt, wt, wt, wt, wt, wt, wm, wm, wm, wm, wm, wm, wm, wt, wt, wt, wt, wt, wt,
            wt, wt, wt, wt, wt, wt, wm, wm, wm, wm, wm, wm, wt, wt, wt, wt, wt, wt, wt, wt, wm, wm, wm, wm, wm, wt, wt, wt, wt, wt, wt, wt,
            wt, wt, wt, wt, wt, wt, wt, wm, wm, wm, wm, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wm, wm, wm, wt, wt, wt, wt, wt, wt, wt, wt,
            wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt, wt,
        ]
        
        return PremadeSpriteData(id: "sunset", name: "Sunset", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Landscapes", groupOrder: 2)
    }()
    
    // MARK: - Castle
    
    static let castle: PremadeSpriteData = {
        let c = "clear"
        let sk = "#0099db"
        let sl = "#00cdf9"
        let w = "#c0cbdc"
        let s = "#92a1b9"
        let d = "#657392"
        let k = "#424c6e"
        let b = "#131313"
        let r = "#891e2b"
        let rl = "#ea323c"
        let g = "#33984b"
        let gd = "#1e6f50"
        let gl = "#5ac54f"
        let e = "#8a4836"
        let ed = "#5d2c28"
        let y = "#edab50"
        let fl = "#e07438"
        
        let grid: [String] = [
          
            sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk,
            sl, sk, sk, sk, sk, sk, sk, sk, y, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, y, sk, sk, sk, sk, sk, sk, sk, sk, sl,
            sl, sk, sk, sk, sk, sk, sk, sk, fl, sk, sk, sk, sk, sk, sk, y, y, sk, sk, sk, sk, sk, fl, sk, sk, sk, sk, sk, sk, sk, sk, sl,
            sl, sl, sk, sk, sk, sk, sk, sk, fl, sk, sk, sk, sk, sk, sk, fl, fl, sk, sk, sk, sk, sk, fl, sk, sk, sk, sk, sk, sk, sl, sl, sl,
          
            sl, sl, sk, sk, sk, sk, sk, w, fl, w, sk, sk, sk, sk, w, fl, fl, w, sk, sk, sk, sk, w, fl, w, sk, sk, sk, sk, sl, sl, sl,
            sl, sl, sk, sk, sk, sk, w, s, w, s, w, sk, sk, w, s, d, d, s, w, sk, sk, w, s, w, s, w, sk, sk, sk, sl, sl, sl,
            sl, sl, sk, sk, sk, w, s, w, b, w, s, w, sk, s, w, s, s, w, s, sk, w, s, w, b, w, s, w, sk, sk, sl, sl, sl,
            sl, sl, sk, sk, sk, k, d, s, d, s, d, k, sk, k, d, s, s, d, k, sk, k, d, s, d, s, d, k, sk, sk, sl, sl, sl,
           
            sl, sl, sk, sk, sk, d, s, s, b, s, s, d, sk, d, s, s, s, s, d, sk, d, s, s, b, s, s, d, sk, sk, sl, sl, sl,
            sl, sl, sk, sk, sk, d, s, b, b, b, s, d, sk, d, s, b, b, s, d, sk, d, s, b, b, b, s, d, sk, sk, sl, sl, sl,
            sl, sl, sk, sk, sk, d, s, s, b, s, s, d, sk, d, s, b, b, s, d, sk, d, s, s, b, s, s, d, sk, sk, sl, sl, sl,
            sl, sl, sk, sk, sk, d, s, s, s, s, s, d, d, d, s, s, s, s, d, d, d, s, s, s, s, s, d, sk, sk, sl, sl, sl,
         
            sl, sl, sk, sk, sk, d, s, s, s, s, s, s, s, s, s, s, s, s, s, s, s, s, s, s, s, s, d, sk, sk, sl, sl, sl,
            sl, sl, sk, sk, sk, d, s, s, b, s, s, s, s, s, s, rl, r, s, s, s, s, s, b, s, s, s, d, sk, sk, sl, sl, sl,
            sl, sl, sk, sk, sk, d, s, s, s, s, s, s, s, d, d, r, r, d, d, s, s, s, s, s, s, s, d, sk, sk, sl, sl, sl,
            sl, sl, sk, sk, sk, k, d, s, s, s, d, d, d, d, k, b, b, k, d, d, d, d, s, s, s, d, k, sk, sk, sl, sl, sl,
           
            sl, sl, sk, sk, sk, k, d, s, s, d, k, s, s, k, b, b, b, b, k, s, s, k, d, s, s, d, k, sk, sk, sl, sl, sl,
            sl, sl, sk, sk, sk, k, d, d, d, k, k, s, k, b, b, b, b, b, b, k, s, k, k, d, d, d, k, sk, sk, sl, sl, sl,
            sl, sl, sk, sk, sk, k, k, k, k, k, k, k, k, b, b, b, b, b, b, k, k, k, k, k, k, k, k, sk, sk, sl, sl, sl,
            sl, sl, sl, sk, sk, k, k, k, k, k, k, k, k, b, b, b, b, b, b, k, k, k, k, k, k, k, k, sk, sl, sl, sl, sl,
           
            g, g, g, gl, g, k, k, k, k, k, k, k, k, k, k, e, e, k, k, k, k, k, k, k, k, k, k, g, gl, g, g, g,
            g, gd, g, g, gl, g, g, g, g, g, g, g, g, e, e, e, e, e, e, g, g, g, g, g, g, g, g, gl, g, g, gd, g,
            gd, g, g, gl, g, g, gd, g, g, g, g, g, e, e, e, e, e, e, e, e, g, g, g, g, g, gd, g, g, gl, g, g, gd,
            g, gd, g, g, g, gd, g, g, gd, g, g, e, e, e, ed, e, e, ed, e, e, e, g, g, gd, g, g, gd, g, g, g, gd, g,
        
            gd, g, gl, g, g, g, g, g, g, g, e, e, e, ed, ed, e, e, ed, ed, e, e, e, g, g, g, g, g, g, g, gl, g, gd,
            g, g, g, gl, g, gd, g, g, g, e, e, ed, ed, ed, e, e, e, e, ed, ed, ed, e, e, g, g, g, gd, g, gl, g, g, g,
            gd, g, g, g, g, g, g, g, e, e, ed, ed, ed, e, e, e, e, e, e, ed, ed, ed, e, e, g, g, g, g, g, g, g, gd,
            e, gd, g, g, gd, g, g, e, e, ed, ed, ed, e, e, e, e, e, e, e, e, ed, ed, ed, e, e, g, g, gd, g, g, gd, e,
            
            e, e, gd, gd, g, gd, e, e, ed, ed, ed, e, e, e, e, e, e, e, e, e, e, ed, ed, ed, e, e, gd, g, gd, gd, e, e,
            e, e, e, e, gd, e, e, ed, ed, ed, e, e, e, e, e, e, e, e, e, e, e, e, ed, ed, ed, e, e, gd, e, e, e, e,
            e, e, e, e, e, e, ed, ed, ed, e, e, e, e, e, e, e, e, e, e, e, e, e, e, ed, ed, ed, e, e, e, e, e, e,
            e, e, e, e, e, ed, ed, ed, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, ed, ed, ed, e, e, e, e, e,
        ]
        
        return PremadeSpriteData(id: "castle", name: "Castle", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Landscapes", groupOrder: 3)
    }()
    
    // MARK: - Ocean
    
    static let ocean: PremadeSpriteData = {
        let c = "clear"
        let sk = "#94fdff"
        let sb = "#00cdf9"
        let sd = "#0099db"
        let wl = "#0069aa"
        let wm = "#00396d"
        let wd = "#0c2e44"
        let ww = "#ffffff"
        let wf = "#c0cbdc"
        let sn = "#e4d2aa"
        let ss = "#e4a672"
        let sw = "#b86f50"
        let sh = "#ea323c"
        let sg = "#33984b"
        
        let grid: [String] = [
    
            sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb,
            sk, sk, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sk, sk,
            sk, sk, sk, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sk, sk, sk,
            sk, sk, sk, sk, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sk, sk, sk, sk,
     
            sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd,
            sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd, sd,
            wl, wl, sd, sd, sd, sd, wl, wl, sd, sd, sd, sd, sd, wl, sd, sd, sd, sd, wl, wl, sd, sd, sd, sd, wl, sd, sd, sd, sd, wl, wl, wl,
            wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, sd, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, sd, wl, wl, wl, wl,
         
            wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl,
            wl, wl, wl, wl, wl, ww, ww, wl, wl, wl, wl, wl, wl, wl, wl, ww, ww, wl, wl, wl, wl, wl, wl, wl, ww, ww, wl, wl, wl, wl, wl, wl,
            wl, wl, wl, wl, ww, ww, ww, ww, wl, wl, wl, wl, wl, wl, ww, ww, ww, ww, wl, wl, wl, wl, wl, ww, ww, ww, ww, wl, wl, wl, wl, wl,
            wl, wl, wl, ww, ww, wf, wf, ww, ww, wl, wl, wl, wl, ww, ww, wf, wf, ww, ww, wl, wl, wl, ww, ww, wf, wf, ww, ww, wl, wl, wl, wl,
        
            wm, wl, ww, ww, wf, wl, wl, wf, ww, ww, wl, wl, ww, ww, wf, wl, wl, wf, ww, ww, wl, ww, ww, wf, wl, wl, wf, ww, ww, wl, wl, wm,
            wm, wl, wl, wf, wl, wl, wl, wl, wf, wl, wl, wl, wl, wf, wl, wl, wl, wl, wf, wl, wl, wl, wf, wl, wl, wl, wl, wf, wl, wl, wl, wm,
            wm, wm, wl, wl, wl, wl, wl, wl, wl, wl, wm, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wm, wm, wm,
            wm, wm, wm, wl, wl, wl, wl, wl, wl, wm, wm, wl, wl, wl, wl, wl, wl, wl, wl, wl, wm, wl, wl, wl, wl, wl, wl, wl, wm, wm, wm, wm,
         
            wm, wm, wm, wl, wl, wl, wm, wl, wl, wm, wm, wm, wl, wl, wm, wl, wl, wm, wl, wl, wm, wm, wl, wl, wm, wl, wl, wl, wm, wm, wm, wm,
            wm, wm, wl, wl, wl, wl, wl, wl, wm, wm, wm, wl, wl, wl, wl, wl, wl, wl, wl, wl, wm, wl, wl, wl, wl, wl, wl, wm, wm, wm, wm, wm,
            ww, ww, ww, wl, wl, ww, ww, ww, ww, wm, wl, wl, ww, ww, ww, wl, wl, ww, ww, ww, wl, wl, ww, ww, ww, ww, wl, wl, ww, ww, wm, wm,
            wf, ww, ww, ww, ww, ww, wf, wf, ww, ww, ww, ww, ww, wf, ww, ww, ww, ww, wf, ww, ww, ww, ww, wf, wf, ww, ww, ww, ww, ww, ww, wf,
          
            sw, wf, wf, ww, ww, wf, sw, sw, wf, ww, ww, wf, wf, sw, wf, ww, ww, wf, sw, wf, ww, wf, wf, sw, sw, wf, ww, ww, wf, wf, wf, sw,
            sw, sw, sw, wf, wf, sw, sw, sw, sw, wf, wf, sw, sw, sw, sw, wf, wf, sw, sw, sw, wf, sw, sw, sw, sw, sw, wf, wf, sw, sw, sw, sw,
            sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw,
            ss, sw, sw, sw, sw, sw, ss, ss, sw, sw, sw, sw, sw, ss, sw, sw, sw, sw, ss, sw, sw, sw, sw, ss, ss, sw, sw, sw, sw, sw, ss, ss,
            
            sn, ss, ss, sw, sw, ss, sn, sn, ss, ss, sw, ss, ss, sn, ss, sw, sw, ss, sn, ss, sw, ss, ss, sn, sn, ss, sw, ss, ss, ss, sn, sn,
            sn, sn, sn, ss, ss, sn, sn, sn, sn, ss, ss, sn, sn, sn, sn, ss, ss, sn, sn, sn, ss, sn, sn, sn, sn, sn, ss, sn, sn, sn, sn, sn,
            sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sh, sh, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sg, sn, sn, sn, sn,
            sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sh, sh, sh, sh, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sg, sg, sn, sn, sn, sn,
            
            sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sh, sh, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sg, sn, sn, sn, sn,
            sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn,
            sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn,
            sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn, sn,
        ]
        
        return PremadeSpriteData(id: "ocean", name: "Ocean", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Landscapes", groupOrder: 4)
    }()
    
    // MARK: - Community Sprites (32x32)
    
    static let duck2: PremadeSpriteData = {
        let c = "clear"
        let a = "#111111"
        let b = "#edab50"
        let d = "#ffeb53"
        let e = "#f68187"
        let f = "#c85083"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, a, a, a, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, b, d, a, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, a, b, d, d, a, a, a, a, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, a, b, d, d, d, d, d, d, a, a, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, a, d, d, d, d, d, d, d, d, d, a, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, a, d, d, d, b, d, d, d, d, d, d, a, c, c, c, c, a, a, a, c, c, c, c, c, c, c, c,
            c, c, c, c, a, b, d, d, d, d, b, d, d, d, d, d, d, a, c, c, a, d, d, d, a, c, c, c, c, c, c, c,
            c, c, c, c, a, b, b, d, d, d, d, b, b, b, d, d, d, d, a, a, b, d, d, d, d, a, c, c, c, c, c, c,
            c, c, c, a, a, a, b, b, d, d, d, d, d, d, d, d, d, d, b, b, d, d, a, a, d, a, a, a, c, c, c, c,
            c, c, a, e, e, f, f, b, b, b, b, d, d, d, d, d, d, d, d, d, d, d, d, d, d, f, e, e, a, c, c, c,
            c, c, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]

        return PremadeSpriteData(id: "duck2", name: "Duck 2", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid)
    }()

    static let duck3: PremadeSpriteData = {
        let c = "clear"
        let a = "#1e6e50"
        let b = "#57c54f"
        let d = "#114949"
        let e = "#111111"
        let f = "#309848"
        let g = "#e07137"
        let h = "#ffa214"
        let i = "#ffc822"
        let j = "#ffeb54"
        let k = "#edab50"
        let l = "#ffffff"
        let m = "#c7cfdd"
        let n = "#838383"
        let p = "#8a4536"
        let q = "#bf6e47"
        let r = "#b4b4b4"
        let t = "#92a1b9"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, a, a, a, a, a, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, a, b, b, b, b, d, e, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, e, b, b, b, b, b, b, a, e, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, e, b, b, b, b, b, b, f, e, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, g, g, g, h, i, i, f, b, e, f, f, e, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, g, j, j, i, i, k, g, f, e, f, f, e, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, g, i, i, h, g, g, g, f, b, b, f, e, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, e, e, e, e, f, f, f, f, f, a, e, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, e, f, f, f, f, e, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, e, l, l, l, m, e, c, c, c, n, n, n, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, p, n, q, q, q, n, e, e, e, r, m, m, e, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, p, q, q, q, q, q, q, t, m, m, m, m, m, e, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, p, q, c, q, q, q, q, m, m, m, m, m, m, m, e, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, p, q, q, q, q, q, t, m, m, m, m, m, m, m, e, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, p, q, q, q, q, m, m, m, m, m, m, m, m, n, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, e, n, q, q, q, t, m, m, m, m, m, m, m, e, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, e, p, p, p, p, r, r, r, r, r, r, r, e, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, e, p, p, p, r, r, r, r, r, r, e, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, e, e, e, e, e, e, k, e, e, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, e, g, e, e, k, e, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, e, g, g, e, k, k, e, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, e, e, e, e, e, e, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]

        return PremadeSpriteData(id: "duck3", name: "Duck 3", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid)
    }()

    static let duck5: PremadeSpriteData = {
        let c = "clear"
        let a = "#111111"
        let b = "#ffeb55"
        let d = "#f68187"
        let e = "#c7cfdd"
        let f = "#0067aa"
        let g = "#ea303a"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, a, a, a, a, a, a, a, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, a, a, b, b, b, b, b, b, b, a, a, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, b, a, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, b, b, b, a, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, b, b, b, b, a, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, a, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, b, b, b, a, a, b, b, a, a, a, a, b, b, a, a, b, a, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, b, b, b, a, a, b, a, d, d, d, d, a, b, a, a, b, b, a, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, b, b, b, b, b, a, a, a, a, a, a, a, a, b, b, b, b, a, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, b, b, b, b, b, a, d, d, d, d, d, d, a, b, b, b, b, a, c, c, c, c, c, c, c,
            c, c, c, c, c, a, b, b, b, b, b, b, b, a, a, a, a, a, a, b, b, b, b, b, a, a, c, c, c, c, c, c,
            c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, a, b, a, c, c, c, c, c,
            c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, a, b, b, a, c, c, c, c,
            c, c, c, c, a, b, b, b, a, b, b, b, b, b, b, a, a, a, b, b, b, b, b, b, a, b, b, a, c, c, c, c,
            c, c, c, c, a, b, b, a, b, b, b, a, a, a, a, e, e, a, b, b, b, b, b, b, a, a, b, a, c, c, c, c,
            c, c, c, c, a, b, b, a, a, a, a, e, e, e, e, e, e, a, b, b, b, b, b, b, a, c, a, a, c, c, c, c,
            c, c, c, c, a, b, b, a, f, f, e, e, e, e, e, e, a, b, b, b, b, b, b, b, a, c, c, c, c, c, c, c,
            c, c, c, c, a, a, b, a, a, a, e, e, e, e, a, a, b, b, b, b, b, b, b, b, a, c, c, c, c, c, c, c,
            c, c, c, c, c, a, a, b, b, b, a, a, a, a, b, b, b, b, b, b, b, b, b, b, a, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, a, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, a, a, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, a, a, a, b, b, b, b, b, b, b, b, b, b, b, b, a, g, a, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, a, g, g, a, b, b, b, b, b, b, b, b, b, a, a, g, g, a, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, a, a, g, g, a, a, a, a, a, a, a, a, a, g, g, g, a, a, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, a, a, a, a, c, c, c, c, c, c, c, a, a, a, a, a, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]

        return PremadeSpriteData(id: "duck5", name: "Duck 5", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid)
    }()

    static let ducks1: PremadeSpriteData = {
        let c = "clear"
        let a = "#111111"
        let b = "#ffffff"
        let d = "#c7cfdd"
        let e = "#1c111c"
        let f = "#ffc822"
        let g = "#ffa214"
        let h = "#ed7314"
        let i = "#fdd2ed"
        let j = "#ffeb54"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, a, a, a, a, a, a, a, a, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, a, a, b, b, b, b, d, d, d, d, a, a, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, d, d, d, a, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, d, d, d, d, a, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, b, b, d, d, a, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, a, b, b, b, b, b, b, b, e, e, b, b, b, b, b, d, d, a, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, a, b, f, f, g, b, b, b, b, b, b, b, b, b, b, d, d, a, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, f, g, h, g, b, b, b, b, i, i, b, b, b, b, d, a, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, a, g, g, g, g, g, g, b, b, b, b, b, b, b, b, d, a, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, a, h, h, h, h, g, g, g, b, b, b, b, b, b, d, a, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, a, d, b, b, b, b, b, b, b, b, b, d, b, b, a, a, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, b, b, d, d, d, d, d, d, d, d, d, b, b, b, b, b, a, c, c, c, c, c, c, c, c,
            c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, a, a, c, c, c, c, c, c,
            c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, d, a, a, a, a, c, c,
            c, c, c, c, a, b, b, b, b, b, b, b, b, d, b, b, b, b, b, b, b, b, b, b, b, d, b, b, b, a, c, c,
            c, c, c, a, d, b, b, b, b, b, b, b, b, d, b, b, b, b, b, b, b, b, b, b, b, d, b, b, d, a, c, c,
            c, c, c, a, d, b, b, b, b, b, b, b, b, b, d, b, b, b, b, b, b, b, b, b, d, b, b, d, a, c, c, c,
            c, c, c, a, d, b, b, b, b, b, b, b, b, b, b, d, b, b, b, b, b, b, b, d, b, b, d, a, c, c, c, c,
            c, c, c, a, d, b, b, b, b, b, b, b, b, b, b, b, d, d, d, d, d, d, d, b, b, d, a, c, c, c, c, c,
            c, c, c, a, d, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, d, a, c, c, c, c, c,
            c, c, c, c, a, d, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, d, a, c, c, c, c, c,
            c, c, c, c, a, d, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, d, a, c, c, c, c, c, c,
            c, c, c, c, c, a, d, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, b, d, a, c, c, c, c, c, c, c,
            c, c, c, c, c, a, d, b, b, b, b, b, b, b, b, b, b, b, b, b, b, d, d, a, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, d, d, d, d, d, d, d, d, d, d, d, d, d, d, a, a, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, a, a, h, h, h, h, a, a, a, a, h, h, h, h, a, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, a, g, g, g, g, a, c, c, a, g, g, g, g, a, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, a, j, f, f, f, f, a, c, a, f, j, f, f, f, a, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, j, f, f, f, f, f, a, a, f, j, f, f, f, f, f, a, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, c, c, c, c, c, c, c, c, c,
        ]

        return PremadeSpriteData(id: "ducks1", name: "Ducks 1", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid)
    }()

    static let pokemonBall: PremadeSpriteData = {
        let c = "clear"
        let a = "#111111"
        let b = "#ff0040"
        let d = "#c7cfdd"
        let e = "#ffffff"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, a, a, a, a, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, a, a, b, b, b, b, a, a, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, a, b, b, b, b, b, b, b, b, a, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, a, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, a, b, b, b, b, b, b, b, b, b, b, a, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, a, b, b, b, b, b, a, a, b, b, b, b, b, a, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, a, b, b, b, b, a, d, d, a, b, b, b, b, a, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, a, a, a, a, a, a, d, d, a, a, a, a, a, a, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, a, e, e, e, e, e, a, a, e, e, e, e, e, a, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, a, e, e, e, e, e, e, e, e, e, e, a, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, a, e, e, e, e, e, e, e, e, e, e, a, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, a, e, e, e, e, e, e, e, e, a, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, a, a, e, e, e, e, a, a, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, a, a, a, a, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]

        return PremadeSpriteData(id: "pokemonBall", name: "Pokémon Ball", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid)
    }()
}

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
        let sk = "#94fdff"  // sky light
        let sb = "#00cdf9"  // sky blue
        let sd = "#0099db"  // sky deep
        let g = "#33984b"   // green mid
        let gd = "#1e6f50"  // green dark
        let gl = "#5ac54f"  // green light
        let gx = "#99e65f"  // green bright
        let t = "#5d2c28"   // trunk brown
        let td = "#391f21"  // trunk dark
        let e = "#8a4836"   // earth brown
        let ed = "#5d2c28"  // earth dark
        let fl = "#ffeb57"  // flower yellow
        let fr = "#ea323c"  // flower red
        let fm = "#f68187"  // flower pink
        let mr = "#ea323c"  // mushroom red cap
        let mw = "#ffffff"  // mushroom spots
        let ms = "#e4a672"  // mushroom stem
        
        let grid: [String] = [
            sk, sk, sk, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sk, sk, sk,
            sk, sk, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sk, sk,
            sk, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sk,
            sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb,
            sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, gd, gd, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb,
            sb, sb, sb, sb, sb, sb, sb, gd, sb, sb, sb, sb, sb, sb, gd, g, g, gd, sb, sb, sb, sb, sb, sb, sb, sb, sb, gd, sb, sb, sb, sb,
            sb, sb, sb, sb, sb, sb, gd, gl, gd, sb, sb, sb, sb, gd, g, gl, gl, g, gd, sb, sb, sb, sb, sb, sb, sb, gd, gl, gd, sb, sb, sb,
            sb, sb, sb, sb, sb, gd, gl, gx, gl, gd, sb, sb, gd, g, gl, gx, gx, gl, g, gd, sb, sb, sb, sb, sb, gd, gl, gx, gl, gd, sb, sb,
            sb, sb, sb, sb, gd, gl, gx, gx, gx, gl, gd, gd, g, gl, gx, gx, gx, gx, gl, g, gd, sb, sb, sb, gd, gl, gx, gx, gx, gl, gd, sb,
            sb, sb, sb, gd, gl, gx, gx, gx, gx, gx, gl, g, gl, gx, gx, gx, gx, gx, gx, gl, g, gd, sb, gd, gl, gx, gx, gx, gx, gx, gl, gd,
            sb, sb, gd, gl, gx, gx, gx, gx, gx, gx, gx, gl, gx, gx, gl, gx, gx, gl, gx, gx, gl, g, gd, gl, gx, gx, gx, gx, gx, gx, gx, gl,
            sb, gd, g, gx, gx, gl, gx, gx, gl, gx, gx, gx, gx, gl, g, gl, gl, g, gl, gx, gx, gl, gx, gx, gx, gl, gx, gx, gl, gx, gx, gx,
            gd, g, gl, gx, gl, g, gd, gl, g, gl, gx, gx, gl, g, gd, t, t, gd, g, gl, gx, gx, gx, gx, gl, g, gd, gl, g, gl, gx, gx,
            g, gd, g, gl, g, gd, gd, g, gd, g, gl, gl, g, gd, gd, t, t, gd, gd, g, gl, gx, gl, gl, g, gd, gd, g, gd, g, gl, gl,
            gd, gd, gd, g, gd, gd, gd, gd, gd, gd, g, g, gd, gd, gd, t, t, gd, gd, gd, g, gl, g, g, gd, gd, gd, gd, gd, gd, g, g,
            gd, gd, gd, gd, gd, gd, gd, gd, gd, gd, gd, gd, gd, gd, gd, t, t, gd, gd, gd, gd, g, gd, gd, gd, gd, gd, gd, gd, gd, gd, gd,
            gd, gd, g, gd, gd, gd, g, t, t, gd, gd, gd, gd, gd, gd, t, t, gd, gd, gd, gd, gd, gd, gd, t, t, gd, gd, g, gd, gd, gd,
            gd, g, gl, g, gd, g, t, t, t, t, gd, gd, gd, gd, gd, t, t, gd, gd, gd, gd, gd, gd, t, t, t, t, gd, gl, g, gd, gd,
            g, gl, gx, gl, g, t, t, td, td, t, t, gd, gd, gd, gd, t, t, gd, gd, gd, gd, gd, t, t, td, td, t, t, gx, gl, g, gd,
            gl, gx, gx, gx, g, t, td, td, td, t, g, gd, gd, g, gd, t, t, gd, g, gd, gd, g, t, td, td, td, t, gx, gx, gx, gl, g,
            gx, gx, gx, gl, g, t, td, g, td, t, g, gl, gl, g, gd, t, t, gd, g, gl, gl, g, t, td, g, td, t, gx, gx, gx, gx, gl,
            gl, gx, gl, g, g, t, g, g, g, t, gd, g, g, gd, gd, t, t, gd, gd, g, g, gd, t, g, g, g, t, gl, gx, gl, gx, gx,
            g, gl, g, gd, g, t, gd, gd, gd, t, gd, gd, gd, gd, gd, t, t, gd, gd, gd, gd, gd, t, gd, gd, gd, t, g, gl, g, gl, gl,
            gd, g, gd, gd, gd, t, gd, gd, gd, t, gd, gd, gd, gd, gd, t, t, gd, gd, gd, gd, gd, t, gd, gd, gd, t, gd, g, gd, g, g,
            g, gl, g, fl, g, g, gd, gd, g, g, gl, g, fr, g, g, gl, g, g, fm, g, gl, g, g, gd, gd, g, g, fl, gl, g, gd, gd,
            gd, g, gl, g, gl, gd, gd, gd, gl, g, g, gl, g, gl, g, g, gl, g, g, gl, g, gl, gd, gd, gd, gl, g, g, g, gd, gd, gd,
            e, gd, g, mr, g, gd, e, gd, g, gd, e, gd, g, g, gd, e, gd, g, gd, g, e, gd, mr, g, gd, g, gd, e, gd, gd, e, e,
            e, e, gd, mw, mr, e, e, e, gd, gd, e, e, gd, gd, e, e, e, gd, e, gd, e, e, mw, mr, gd, gd, e, e, e, e, e, e,
            e, e, e, ms, ms, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, e, ms, ms, e, e, e, e, e, e, e, e,
            e, e, ed, e, e, e, e, ed, e, e, e, e, ed, e, e, e, ed, e, e, e, ed, e, e, e, e, ed, e, e, e, ed, e, e,
            e, ed, ed, ed, e, ed, ed, ed, e, e, ed, ed, ed, e, ed, ed, ed, ed, e, ed, ed, ed, e, e, ed, ed, ed, e, ed, ed, ed, e,
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
    
    // MARK: - Street at Night
    
    static let streetAtNight: PremadeSpriteData = {
        let c = "clear"
        let nk = "#0c2e44"  // night sky dark
        let ns = "#00396d"  // night sky mid
        let nl = "#0069aa"  // night sky light
        let st = "#ffeb57"  // star yellow
        let mn = "#f4d29c"  // moon cream
        let md = "#e4a672"  // moon dark
        let bk = "#391f21"  // building dark
        let bm = "#5d2c28"  // building mid
        let bl = "#3d3d3d"  // building gray
        let yw = "#ffeb57"  // window yellow lit
        let wd = "#edab50"  // window dim
        let wf = "#131313"  // window off
        let rd = "#424c6e"  // road dark
        let rm = "#657392"  // road mid
        let rl = "#c0cbdc"  // road line white
        let sw = "#0098dc"  // sidewalk
        let lp = "#e4a672"  // lamp post
        let lg = "#ffeb57"  // lamp glow
        let lr = "#ffa214"  // lamp glow ring
        
        let grid: [String] = [
            nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk,
            nk, nk, nk, nk, st, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, st, nk, nk, nk, nk, nk, nk, nk, nk,
            nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, st, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, mn, mn, nk, nk, nk,
            nk, nk, nk, nk, nk, nk, nk, nk, st, nk, nk, nk, nk, nk, nk, nk, nk, nk, st, nk, nk, nk, nk, nk, nk, nk, mn, mn, md, nk, nk, nk,
            ns, ns, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, mn, nk, nk, ns, ns,
            ns, ns, ns, nk, nk, nk, nk, nk, nk, nk, nk, bk, bk, bk, bk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, nk, ns, ns, ns,
            ns, ns, ns, nk, nk, nk, bk, bk, bk, nk, bk, bm, bm, bm, bm, bk, nk, nk, nk, nk, bk, bk, bk, bk, bk, nk, nk, nk, ns, ns, ns, ns,
            ns, ns, ns, nk, nk, bk, bm, bm, bm, bk, bk, bm, yw, bm, yw, bk, nk, nk, nk, bk, bm, bm, bm, bm, bm, bk, nk, nk, ns, ns, ns, ns,
            nl, ns, ns, nk, bk, bm, yw, bm, yw, bk, bk, bm, bm, bm, bm, bk, nk, nk, bk, bm, yw, bm, wf, bm, yw, bm, bk, nk, ns, ns, ns, nl,
            nl, ns, ns, nk, bk, bm, bm, bm, bm, bk, bk, bm, yw, bm, yw, bk, nk, nk, bk, bm, bm, bm, bm, bm, bm, bm, bk, nk, ns, ns, ns, nl,
            nl, ns, ns, nk, bk, bm, yw, bm, wf, bk, bk, bm, bm, bm, bm, bk, lr, lr, bk, bm, yw, bm, yw, bm, wf, bm, bk, nk, ns, ns, ns, nl,
            nl, nl, ns, bk, bk, bm, bm, bm, bm, bk, bk, bm, wf, bm, yw, bk, lg, lg, bk, bm, bm, bm, bm, bm, bm, bm, bk, nk, ns, ns, nl, nl,
            nl, nl, ns, bk, bk, bm, yw, bm, yw, bk, bk, bm, bm, bm, bm, bk, lp, lp, bk, bm, wf, bm, yw, bm, yw, bm, bk, bk, ns, ns, nl, nl,
            nl, nl, ns, bk, bk, bm, bm, bm, bm, bk, bk, bm, yw, bm, wf, bk, lp, lp, bk, bm, bm, bm, bm, bm, bm, bm, bk, bk, ns, ns, nl, nl,
            nl, nl, ns, bk, bk, bk, bk, bk, bk, bk, bk, bk, bk, bk, bk, bk, lp, lp, bk, bk, bk, bk, bk, bk, bk, bk, bk, bk, ns, nl, nl, nl,
            nl, nl, nl, bk, bk, bk, bk, bk, bk, bk, bk, bk, bk, bk, bk, bk, lp, lp, bk, bk, bk, bk, bk, bk, bk, bk, bk, bk, nl, nl, nl, nl,
            sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw,
            sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw,
            rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd,
            rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd,
            rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd,
            rm, rm, rm, rm, rm, rd, rd, rd, rd, rm, rm, rm, rm, rm, rd, rd, rd, rd, rm, rm, rm, rm, rm, rd, rd, rd, rd, rm, rm, rm, rm, rm,
            rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd,
            rl, rl, rl, rl, rd, rd, rd, rd, rl, rl, rl, rl, rd, rd, rd, rd, rl, rl, rl, rl, rd, rd, rd, rd, rl, rl, rl, rl, rd, rd, rd, rd,
            rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd,
            rm, rm, rm, rm, rm, rd, rd, rd, rd, rm, rm, rm, rm, rm, rd, rd, rd, rd, rm, rm, rm, rm, rm, rd, rd, rd, rd, rm, rm, rm, rm, rm,
            rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd,
            rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd, rd,
            sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw,
            sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw,
            bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl,
            bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl, bl,
        ]
        
        return PremadeSpriteData(id: "street_at_night", name: "Street at Night", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Landscapes", groupOrder: 5)
    }()
    
    // MARK: - Study Room
    
    static let studyRoom: PremadeSpriteData = {
        let c = "clear"
        let wl = "#e8d4b8"  // wall light
        let wd = "#d2b48c"  // wall dark/trim
        let fl = "#8a4836"  // floor wood
        let fd = "#5d2c28"  // floor dark
        let dk = "#391f21"  // desk dark
        let dm = "#5d2c28"  // desk mid
        let dl = "#8a4836"  // desk light
        let dt = "#bf6f4a"  // desk top
        let bk = "#391f21"  // bookshelf dark
        let bm = "#5d2c28"  // bookshelf mid
        let br = "#ea323c"  // book red
        let bg = "#33984b"  // book green
        let bb = "#0098dc"  // book blue
        let by = "#edab50"  // book yellow
        let bp = "#c32454"  // book purple
        let wn = "#94fdff"  // window sky
        let wf = "#c0cbdc"  // window frame
        let wg = "#657392"  // window frame dark
        let lm = "#ffeb57"  // lamp glow
        let lo = "#ffa214"  // lamp orange
        let ls = "#e4a672"  // lamp shade
        let lp = "#391f21"  // lamp post
        let ch = "#bf6f4a"  // chair
        let cd = "#8a4836"  // chair dark
        let pp = "#ffffff"  // paper white
        let pg = "#c0cbdc"  // paper lines
        let pc = "#0e071b"  // pencil
        let mg = "#f68187"  // mug pink
        let md = "#c32454"  // mug dark
        
        let grid: [String] = [
            wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl,
            wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl,
            wl, wl, bk, bk, bk, bk, bk, bk, wl, wl, wl, wl, wg, wg, wg, wg, wg, wg, wg, wg, wl, wl, wl, wl, wl, lm, lm, lm, wl, wl, wl, wl,
            wl, wl, bk, br, bg, bb, by, bk, wl, wl, wl, wl, wg, wn, wn, wn, wf, wn, wn, wg, wl, wl, wl, wl, wl, ls, lo, ls, wl, wl, wl, wl,
            wl, wl, bk, br, bg, bb, by, bk, wl, wl, wl, wl, wg, wn, wn, wn, wf, wn, wn, wg, wl, wl, wl, wl, wl, wl, ls, wl, wl, wl, wl, wl,
            wl, wl, bk, bk, bk, bk, bk, bk, wl, wl, wl, wl, wg, wn, wn, wn, wf, wn, wn, wg, wl, wl, wl, wl, wl, wl, lp, wl, wl, wl, wl, wl,
            wl, wl, bk, bp, br, bg, bb, bk, wl, wl, wl, wl, wg, wn, wn, wn, wf, wn, wn, wg, wl, wl, wl, wl, wl, wl, lp, wl, wl, wl, wl, wl,
            wl, wl, bk, bp, br, bg, bb, bk, wl, wl, wl, wl, wg, wn, wn, wn, wf, wn, wn, wg, wl, wl, wl, wl, wl, wl, lp, wl, wl, wl, wl, wl,
            wl, wl, bk, bk, bk, bk, bk, bk, wl, wl, wl, wl, wg, wg, wg, wg, wg, wg, wg, wg, wl, wl, wl, wl, wl, wl, lp, wl, wl, wl, wl, wl,
            wl, wl, bk, by, bg, br, bp, bk, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, lp, wl, wl, wl, wl, wl,
            wl, wl, bk, by, bg, br, bp, bk, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, lp, wl, wl, wl, wl, wl,
            wl, wl, bk, bk, bk, bk, bk, bk, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, lp, wl, wl, wl, wl, wl,
            wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd, wd,
            wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl, wl,
            wl, wl, wl, wl, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, wl, wl, wl, wl,
            wl, wl, wl, wl, dt, dt, dt, dt, pp, pp, pp, pp, dt, dt, pc, dt, dt, mg, md, dt, dt, dt, dt, dt, lp, lp, dt, dt, wl, wl, wl, wl,
            wl, wl, wl, wl, dt, dt, dt, dt, pp, pg, pg, pp, dt, pc, pc, dt, dt, mg, mg, md, dt, dt, dt, dt, lp, lm, dt, dt, wl, wl, wl, wl,
            wl, wl, wl, wl, dt, dt, dt, dt, pp, pp, pp, pp, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, dt, wl, wl, wl, wl,
            wl, wl, wl, wl, dk, dl, dl, dl, dl, dl, dl, dl, dl, dl, dl, dl, dl, dl, dl, dl, dl, dl, dl, dl, dl, dl, dl, dk, wl, wl, wl, wl,
            wl, wl, wl, wl, dk, dm, dm, dm, dm, dm, dm, dm, dm, dm, dm, dm, dm, dm, dm, dm, dm, dm, dm, dm, dm, dm, dm, dk, wl, wl, wl, wl,
            wl, wl, wl, wl, wl, dk, dk, wl, wl, wl, wl, wl, dk, dk, dk, dk, dk, dk, dk, dk, wl, wl, wl, wl, wl, dk, dk, wl, wl, wl, wl, wl,
            wl, wl, wl, wl, wl, dk, dk, wl, wl, wl, ch, ch, ch, ch, ch, ch, ch, ch, ch, ch, ch, ch, wl, wl, wl, dk, dk, wl, wl, wl, wl, wl,
            wl, wl, wl, wl, wl, wl, wl, wl, wl, ch, ch, cd, ch, ch, ch, ch, ch, ch, cd, ch, ch, ch, ch, wl, wl, wl, wl, wl, wl, wl, wl, wl,
            wl, wl, wl, wl, wl, wl, wl, wl, wl, ch, cd, cd, ch, wl, wl, wl, wl, wl, cd, cd, ch, ch, ch, wl, wl, wl, wl, wl, wl, wl, wl, wl,
            wl, wl, wl, wl, wl, wl, wl, wl, wl, cd, cd, wl, wl, wl, wl, wl, wl, wl, wl, cd, cd, wl, ch, wl, wl, wl, wl, wl, wl, wl, wl, wl,
            fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd,
            fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl,
            fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl,
            fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd,
            fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl,
            fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl, fd, fl, fl, fl,
            fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd, fd,
        ]
        
        return PremadeSpriteData(id: "study_room", name: "Study Room", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Landscapes", groupOrder: 6)
    }()
    
    // MARK: - City Skyrises
    
    static let citySkyrises: PremadeSpriteData = {
        let c = "clear"
        let sk = "#0c2e44"  // night sky dark
        let sm = "#00396d"  // sky mid
        let sl = "#0069aa"  // sky lighter
        let st = "#ffeb57"  // stars
        let b1 = "#3d3d3d"  // building 1 dark gray
        let b2 = "#424c6e"  // building 2 blue-gray
        let b3 = "#657392"  // building 3 light gray
        let b4 = "#391f21"  // building 4 dark brown
        let b5 = "#5d2c28"  // building 5 brown
        let yw = "#ffeb57"  // window lit yellow
        let wd = "#edab50"  // window dim
        let wf = "#131313"  // window off
        let gl = "#c0cbdc"  // glass reflection
        let gd = "#657392"  // glass dark
        let rd = "#ea323c"  // rooftop light red
        let rg = "#33984b"  // rooftop green (garden)
        let an = "#0098dc"  // antenna blue light
        let wh = "#ffffff"  // white light
        let rd2 = "#424c6e" // road
        let rl = "#c0cbdc"  // road line
        let sw = "#3d3d3d"  // sidewalk
        
        let grid: [String] = [
            sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk,
            sk, sk, sk, st, sk, sk, sk, sk, sk, sk, sk, sk, sk, st, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, st, sk, sk, sk, sk, sk,
            sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, rd, sk, sk, st, sk, sk, sk, sk, sk, sk, sk, sk, sk,
            sm, sk, sk, sk, sk, sk, sk, sk, sk, sk, st, sk, sk, sk, sk, sk, sk, sk, sk, rd, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sm,
            sm, sm, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, b2, b2, b2, sk, sk, sk, sk, sk, sk, an, sk, sk, sm, sm,
            sm, sm, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, b2, b2, gl, b2, b2, sk, sk, sk, sk, sk, an, sk, sm, sm, sm,
            sm, sm, sm, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, b2, yw, b2, yw, b2, sk, sk, sk, sk, b3, b3, b3, sm, sm, sm,
            sm, sm, sm, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, sk, b1, b1, b1, b2, b2, yw, b2, b2, sk, sk, sk, b3, b3, gl, b3, b3, sm, sm,
            sl, sm, sm, sk, sk, sk, sk, sk, sk, sk, b4, b4, b4, sk, b1, gl, b1, b2, yw, b2, yw, b2, sk, sk, b3, b3, yw, b3, wf, b3, sm, sm,
            sl, sm, sm, sk, sk, sk, sk, sk, sk, b4, b4, wf, b4, b4, b1, b1, b1, b2, b2, yw, b2, b2, sk, b3, b3, wf, b3, yw, b3, b3, sm, sm,
            sl, sl, sm, b5, b5, b5, b5, sk, sk, b4, yw, b4, yw, b4, b1, yw, b1, b2, yw, b2, wf, b2, b3, b3, yw, b3, wf, b3, yw, b3, sm, sm,
            sl, sl, sm, b5, yw, b5, b5, b5, sk, b4, b4, yw, b4, b4, b1, b1, b1, b2, b2, yw, b2, b2, b3, wf, b3, yw, b3, wf, b3, b3, sm, sl,
            sl, sl, sm, b5, b5, yw, wf, b5, sk, b4, yw, b4, wf, b4, b1, yw, b1, b2, yw, b2, yw, b2, b3, yw, b3, b3, yw, b3, wf, b3, sl, sl,
            sl, sl, sm, b5, yw, b5, yw, b5, b4, b4, b4, yw, b4, b4, b1, b1, b1, b2, b2, wf, b2, b2, b3, b3, wf, b3, b3, yw, b3, b3, sl, sl,
            sl, sl, b5, b5, b5, wf, b5, b5, b4, wf, yw, b4, yw, b4, b1, yw, b1, b2, yw, b2, yw, b2, b3, yw, b3, yw, wf, b3, yw, b3, sl, sl,
            sl, sl, b5, wf, yw, b5, yw, b5, b4, b4, b4, wf, b4, b4, b1, b1, b1, b2, wf, yw, b2, b2, b3, b3, wf, b3, yw, wf, b3, b3, sl, sl,
            sl, sl, b5, yw, b5, yw, b5, b5, b4, yw, wf, b4, yw, b4, b1, yw, b1, b2, yw, b2, wf, b2, b3, yw, b3, wf, b3, yw, wf, b3, sl, sl,
            sl, sl, b5, b5, wf, b5, wf, b5, b4, b4, b4, yw, b4, b4, b1, b1, b1, b2, b2, wf, b2, b2, b3, b3, yw, b3, wf, b3, yw, b3, sl, sl,
            sl, sl, b5, yw, b5, wf, yw, b5, b4, wf, yw, b4, wf, b4, b1, yw, b1, b2, yw, b2, yw, b2, b3, wf, b3, yw, b3, wf, b3, b3, sl, sl,
            sl, sl, b5, b5, yw, b5, b5, b5, b4, b4, b4, wf, b4, b4, b1, b1, b1, b2, wf, yw, b2, b2, b3, yw, wf, b3, yw, b3, wf, b3, sl, sl,
            sl, sl, b5, wf, b5, yw, wf, b5, b4, yw, wf, b4, yw, b4, b1, yw, b1, b2, yw, b2, wf, b2, b3, b3, yw, wf, b3, yw, b3, b3, sl, sl,
            rg, rg, b5, b5, b5, b5, b5, b5, b4, b4, b4, b4, b4, b4, b1, b1, b1, b2, b2, b2, b2, b2, b3, b3, b3, b3, b3, b3, b3, b3, sl, sl,
            sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl, sl,
            sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw,
            rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2,
            rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2,
            rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2,
            rl, rl, rl, rl, rd2, rd2, rd2, rd2, rl, rl, rl, rl, rd2, rd2, rd2, rd2, rl, rl, rl, rl, rd2, rd2, rd2, rd2, rl, rl, rl, rl, rd2, rd2, rd2, rd2,
            rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2,
            rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2, rd2,
            sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw,
            sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw, sw,
        ]
        
        return PremadeSpriteData(id: "city_skyrises", name: "City Skyrises", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid, group: "Landscapes", groupOrder: 7)
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

    static let duck7: PremadeSpriteData = {
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

        return PremadeSpriteData(id: "duck7", name: "Duck 7", canvasSize: .mediumSquare, palette: .endesga64, pixelGrid: grid)
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

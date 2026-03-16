//
//  PremadeSprites.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import Foundation

// MARK: - All 16x16 Non-Character Sprites (Items, Objects, Creatures)

extension PremadeSprites {
    
    // MARK: - Heart (16x16)
    // A classic pixel art heart using reds/pinks from Endesga 64
    
    static let heart: PremadeSpriteData = {
        let c = "clear"
        let d = "#891e2b"  // dark red
        let r = "#ea323c"  // red
        let l = "#f68187"  // light pink
        let w = "#ffffff"  // white highlight
        
        let grid: [String] = [
            // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            // row 1
            c, c, c, d, d, c, c, c, c, c, d, d, c, c, c, c,
            // row 2
            c, c, d, r, r, d, c, c, c, d, r, r, d, c, c, c,
            // row 3
            c, d, r, l, r, r, d, c, d, r, r, r, r, d, c, c,
            // row 4
            c, d, r, w, l, r, r, d, r, r, r, r, r, d, c, c,
            // row 5
            c, d, r, l, r, r, r, r, r, r, r, r, r, d, c, c,
            // row 6
            c, d, r, r, r, r, r, r, r, r, r, r, r, d, c, c,
            // row 7
            c, c, d, r, r, r, r, r, r, r, r, r, d, c, c, c,
            // row 8
            c, c, c, d, r, r, r, r, r, r, r, d, c, c, c, c,
            // row 9
            c, c, c, c, d, r, r, r, r, r, d, c, c, c, c, c,
            // row 10
            c, c, c, c, c, d, r, r, r, d, c, c, c, c, c, c,
            // row 11
            c, c, c, c, c, c, d, r, d, c, c, c, c, c, c, c,
            // row 12
            c, c, c, c, c, c, c, d, c, c, c, c, c, c, c, c,
            // row 13
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            // row 15
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(
            id: "heart",
            name: "Heart",
            canvasSize: .smallSquare,
            palette: .endesga64,
            pixelGrid: grid
        )
    }()
    
    // MARK: - Duck (16x16)
    // A cute pixel duck using yellows/oranges from Endesga 64
    
    static let duck: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"  // outline (near black)
        let y = "#ffeb57"  // yellow body
        let d = "#edab50"  // darker yellow/gold
        let w = "#ffffff"  // white eye
        let e = "#131313"  // eye pupil
        let b = "#e07438"  // beak/feet orange
        
        let grid: [String] = [
            // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            // row 1
            c, c, c, c, c, c, o, o, o, c, c, c, c, c, c, c,
            // row 2
            c, c, c, c, c, o, y, y, y, o, c, c, c, c, c, c,
            // row 3
            c, c, c, c, c, o, y, y, y, y, o, c, c, c, c, c,
            // row 4
            c, c, c, c, o, y, y, w, e, y, o, c, c, c, c, c,
            // row 5
            c, c, c, c, o, y, y, y, y, y, o, o, o, c, c, c,
            // row 6
            c, c, c, c, o, y, y, y, y, o, b, b, o, c, c, c,
            // row 7
            c, c, c, o, o, y, y, y, y, o, b, o, c, c, c, c,
            // row 8
            c, c, o, y, y, y, y, y, y, y, o, c, c, c, c, c,
            // row 9
            c, c, o, y, d, y, y, y, y, y, o, c, c, c, c, c,
            // row 10
            c, c, o, y, y, y, y, y, y, y, o, c, c, c, c, c,
            // row 11
            c, c, c, o, y, y, y, y, y, o, c, c, c, c, c, c,
            // row 12
            c, c, c, c, o, o, o, o, o, c, c, c, c, c, c, c,
            // row 13
            c, c, c, c, o, b, o, o, b, o, c, c, c, c, c, c,
            // row 14
            c, c, c, o, b, b, o, o, b, b, o, c, c, c, c, c,
            // row 15
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(
            id: "duck",
            name: "Duck",
            canvasSize: .smallSquare,
            palette: .endesga64,
            pixelGrid: grid
        )
    }()
    
    // MARK: - Pixel Man (16x16)
    // A simple 2D game character using Endesga 64 colors
    
    static let pixelMan: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"  // outline
        let s = "#bf6f4a"  // skin
        let h = "#5d2c28"  // hair (brown)
        let t = "#0069aa"  // shirt (blue)
        let p = "#3d3d3d"  // pants (dark gray)
        let e = "#ffffff"  // eyes white
        let k = "#131313"  // eye pupil
        let b = "#391f21"  // boots/shoes
        
        let grid: [String] = [
            // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            // row 1
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c,
            // row 2
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            // row 3
            c, c, c, c, o, h, h, h, h, h, h, o, c, c, c, c,
            // row 4
            c, c, c, c, o, s, s, s, s, s, s, o, c, c, c, c,
            // row 5
            c, c, c, c, o, s, e, k, s, e, k, o, c, c, c, c,
            // row 6
            c, c, c, c, o, s, s, s, s, s, s, o, c, c, c, c,
            // row 7
            c, c, c, c, c, o, s, s, s, s, o, c, c, c, c, c,
            // row 8
            c, c, c, c, o, t, t, t, t, t, t, o, c, c, c, c,
            // row 9
            c, c, c, o, s, o, t, t, t, t, o, s, o, c, c, c,
            // row 10
            c, c, c, o, s, o, t, t, t, t, o, s, o, c, c, c,
            // row 11
            c, c, c, c, c, o, t, t, t, t, o, c, c, c, c, c,
            // row 12
            c, c, c, c, c, o, p, p, p, p, o, c, c, c, c, c,
            // row 13
            c, c, c, c, c, o, p, o, o, p, o, c, c, c, c, c,
            // row 14
            c, c, c, c, o, b, b, o, o, b, b, o, c, c, c, c,
            // row 15
            c, c, c, c, o, o, o, c, c, o, o, o, c, c, c, c,
        ]
        
        return PremadeSpriteData(
            id: "pixel_man",
            name: "Pixel Man",
            canvasSize: .smallSquare,
            palette: .endesga64,
            pixelGrid: grid
        )
    }()
    
    // MARK: - Sword (16x16)
    
    static let sword: PremadeSpriteData = {
        let c = "clear"
        let b = "#c0cbdc"  // blade silver
        let d = "#657392"  // blade dark
        let w = "#ffffff"  // shine
        let h = "#5d2c28"  // handle brown
        let g = "#edab50"  // guard gold
        let k = "#391f21"  // pommel dark
        
        let grid: [String] = [
            c, c, c, c, c, c, c, w, c, c, c, c, c, c, c, c, // row 0 - tip
            c, c, c, c, c, c, w, b, w, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, b, b, d, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, b, b, d, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, b, b, d, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, b, b, d, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, b, b, d, c, c, c, c, c, c, c, // row 6
            c, c, c, c, c, c, b, b, d, c, c, c, c, c, c, c, // row 7
            c, c, c, c, c, c, b, b, d, c, c, c, c, c, c, c, // row 8
            c, c, c, g, g, g, g, g, g, g, g, g, c, c, c, c, // row 9 - crossguard
            c, c, c, c, c, c, h, h, c, c, c, c, c, c, c, c, // row 10
            c, c, c, c, c, c, h, h, c, c, c, c, c, c, c, c, // row 11
            c, c, c, c, c, c, h, h, c, c, c, c, c, c, c, c, // row 12
            c, c, c, c, c, c, h, h, c, c, c, c, c, c, c, c, // row 13
            c, c, c, c, c, k, g, g, k, c, c, c, c, c, c, c, // row 14 - pommel
            c, c, c, c, c, c, k, k, c, c, c, c, c, c, c, c, // row 15
        ]
        
        return PremadeSpriteData(id: "sword", name: "Sword", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Tree (16x16)
    
    static let tree: PremadeSpriteData = {
        let c = "clear"
        let g = "#33984b"  // green leaves
        let l = "#5ac54f"  // light green
        let d = "#1e6f50"  // dark green
        let t = "#5d2c28"  // trunk brown
        let k = "#391f21"  // trunk dark
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, l, l, c, c, c, c, c, c, c,
            c, c, c, c, c, c, l, g, g, l, c, c, c, c, c, c,
            c, c, c, c, c, l, g, g, g, g, l, c, c, c, c, c,
            c, c, c, c, l, g, g, l, g, g, g, l, c, c, c, c,
            c, c, c, l, g, g, g, g, g, g, g, g, l, c, c, c,
            c, c, c, c, d, g, g, g, g, g, g, d, c, c, c, c,
            c, c, c, c, c, d, g, l, g, g, d, c, c, c, c, c,
            c, c, c, c, d, g, g, g, g, g, g, d, c, c, c, c,
            c, c, c, d, g, g, g, g, g, g, g, g, d, c, c, c,
            c, c, d, g, g, g, l, g, g, g, g, g, g, d, c, c,
            c, c, c, d, d, d, d, t, t, d, d, d, d, c, c, c,
            c, c, c, c, c, c, c, t, t, c, c, c, c, c, c, c,
            c, c, c, c, c, c, k, t, t, k, c, c, c, c, c, c,
            c, c, c, c, c, c, k, t, t, k, c, c, c, c, c, c,
            c, c, c, c, c, k, k, k, k, k, k, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "tree", name: "Tree", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Mushroom (16x16)
    
    static let mushroom: PremadeSpriteData = {
        let c = "clear"
        let r = "#ea323c"  // red cap
        let d = "#891e2b"  // dark red
        let w = "#ffffff"  // white spots
        let s = "#e4a672"  // stem
        let k = "#b86f50"  // stem dark
        let g = "#33984b"  // grass
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, d, d, d, d, c, c, c, c, c, c,
            c, c, c, c, d, d, r, r, r, r, d, d, c, c, c, c,
            c, c, c, d, r, r, r, w, w, r, r, r, d, c, c, c,
            c, c, d, r, r, w, w, r, r, r, r, r, r, d, c, c,
            c, c, d, r, r, w, r, r, r, w, w, r, r, d, c, c,
            c, c, d, r, r, r, r, r, r, w, r, r, r, d, c, c,
            c, c, c, d, d, d, d, d, d, d, d, d, d, c, c, c,
            c, c, c, c, c, c, s, s, s, s, c, c, c, c, c, c,
            c, c, c, c, c, c, s, s, s, s, c, c, c, c, c, c,
            c, c, c, c, c, k, s, s, s, s, k, c, c, c, c, c,
            c, c, c, c, c, k, s, s, s, s, k, c, c, c, c, c,
            c, c, c, c, k, k, k, k, k, k, k, k, c, c, c, c,
            c, c, g, g, g, g, g, g, g, g, g, g, g, g, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "mushroom", name: "Mushroom", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Star (16x16)
    
    static let star: PremadeSpriteData = {
        let c = "clear"
        let y = "#ffeb57"  // yellow
        let g = "#edab50"  // gold
        let d = "#e07438"  // dark gold
        let w = "#ffffff"  // shine
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, y, y, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, y, y, c, c, c, c, c, c, c,
            c, c, c, c, c, c, y, y, y, y, c, c, c, c, c, c,
            c, c, c, c, c, c, y, w, y, y, c, c, c, c, c, c,
            c, y, y, y, y, y, y, y, y, y, y, y, y, y, y, c,
            c, c, y, y, y, y, y, y, y, y, y, y, y, y, c, c,
            c, c, c, y, g, g, y, y, y, y, g, g, y, c, c, c,
            c, c, c, c, g, g, g, y, y, g, g, g, c, c, c, c,
            c, c, c, c, g, g, g, g, g, g, g, g, c, c, c, c,
            c, c, c, c, g, d, g, g, g, g, d, g, c, c, c, c,
            c, c, c, g, d, d, g, c, c, g, d, d, g, c, c, c,
            c, c, c, g, d, c, c, c, c, c, c, d, g, c, c, c,
            c, c, g, d, c, c, c, c, c, c, c, c, d, g, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "star", name: "Star", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Coin (16x16)
    
    static let coin: PremadeSpriteData = {
        let c = "clear"
        let g = "#edab50"  // gold
        let y = "#ffeb57"  // bright gold
        let d = "#e07438"  // dark gold
        let k = "#8a4836"  // shadow
        let w = "#ffc825"  // highlight
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, d, d, d, d, d, d, c, c, c, c, c,
            c, c, c, c, d, g, g, g, g, g, g, d, c, c, c, c,
            c, c, c, d, g, y, y, g, g, y, y, g, d, c, c, c,
            c, c, c, d, g, y, g, w, w, g, y, g, d, c, c, c,
            c, c, c, d, g, g, w, w, w, w, g, g, d, c, c, c,
            c, c, c, d, g, g, w, w, w, w, g, g, d, c, c, c,
            c, c, c, d, g, g, w, w, w, w, g, g, d, c, c, c,
            c, c, c, d, g, g, w, w, w, w, g, g, d, c, c, c,
            c, c, c, d, g, y, g, w, w, g, y, g, d, c, c, c,
            c, c, c, d, g, y, y, g, g, y, y, g, d, c, c, c,
            c, c, c, c, d, g, g, g, g, g, g, d, c, c, c, c,
            c, c, c, c, c, d, d, d, d, d, d, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "coin", name: "Coin", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Skull (16x16)
    
    static let skull: PremadeSpriteData = {
        let c = "clear"
        let w = "#ffffff"  // bone white
        let b = "#c0cbdc"  // bone gray
        let d = "#657392"  // dark gray
        let k = "#131313"  // eyes/nose black
        let t = "#424c6e"  // teeth shadow
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, d, d, d, d, d, d, c, c, c, c, c,
            c, c, c, c, d, b, b, w, w, b, b, d, c, c, c, c,
            c, c, c, d, b, w, w, w, w, w, w, b, d, c, c, c,
            c, c, c, d, w, w, w, w, w, w, w, w, d, c, c, c,
            c, c, c, d, w, k, k, w, w, k, k, w, d, c, c, c,
            c, c, c, d, w, k, k, w, w, k, k, w, d, c, c, c,
            c, c, c, d, w, w, w, w, w, w, w, w, d, c, c, c,
            c, c, c, d, w, w, w, k, k, w, w, w, d, c, c, c,
            c, c, c, d, b, w, w, w, w, w, w, b, d, c, c, c,
            c, c, c, c, d, b, w, w, w, w, b, d, c, c, c, c,
            c, c, c, c, d, w, t, w, t, w, t, d, c, c, c, c,
            c, c, c, c, d, w, w, w, w, w, w, d, c, c, c, c,
            c, c, c, c, c, d, d, d, d, d, d, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "skull", name: "Skull", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Potion (16x16)
    
    static let potion: PremadeSpriteData = {
        let c = "clear"
        let g = "#657392"  // glass
        let l = "#92a1b9"  // glass light
        let p = "#7a09fa"  // purple liquid
        let d = "#3003d9"  // dark purple
        let w = "#ffffff"  // shine
        let k = "#3d3d3d"  // cork
        let b = "#5d2c28"  // cork dark
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, k, k, k, k, c, c, c, c, c, c,
            c, c, c, c, c, c, b, k, k, b, c, c, c, c, c, c,
            c, c, c, c, c, c, g, l, l, g, c, c, c, c, c, c,
            c, c, c, c, c, c, g, l, l, g, c, c, c, c, c, c,
            c, c, c, c, c, g, g, l, l, g, g, c, c, c, c, c,
            c, c, c, c, g, g, w, l, l, g, g, g, c, c, c, c,
            c, c, c, g, g, p, p, p, p, p, p, g, g, c, c, c,
            c, c, c, g, p, p, p, p, p, p, p, p, g, c, c, c,
            c, c, c, g, p, p, d, p, p, d, p, p, g, c, c, c,
            c, c, c, g, p, p, p, d, d, p, p, p, g, c, c, c,
            c, c, c, g, p, p, p, p, p, p, p, p, g, c, c, c,
            c, c, c, c, g, g, g, g, g, g, g, g, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "potion", name: "Potion", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Shield (16x16)
    
    static let shield: PremadeSpriteData = {
        let c = "clear"
        let b = "#0069aa"  // blue
        let d = "#00396d"  // dark blue
        let g = "#edab50"  // gold trim
        let k = "#e07438"  // dark gold
        let w = "#ffffff"  // emblem
        let s = "#c0cbdc"  // silver
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, g, g, g, g, g, g, g, g, g, g, c, c, c,
            c, c, g, k, b, b, b, b, b, b, b, b, k, g, c, c,
            c, c, g, b, b, b, b, b, b, b, b, b, b, g, c, c,
            c, c, g, b, b, b, b, w, w, b, b, b, b, g, c, c,
            c, c, g, b, b, b, w, s, s, w, b, b, b, g, c, c,
            c, c, g, b, b, w, s, s, s, s, w, b, b, g, c, c,
            c, c, g, b, b, w, s, s, s, s, w, b, b, g, c, c,
            c, c, g, b, b, b, w, s, s, w, b, b, b, g, c, c,
            c, c, g, b, b, b, b, w, w, b, b, b, b, g, c, c,
            c, c, c, g, b, b, b, b, b, b, b, b, g, c, c, c,
            c, c, c, g, d, b, b, b, b, b, b, d, g, c, c, c,
            c, c, c, c, g, d, b, b, b, b, d, g, c, c, c, c,
            c, c, c, c, c, g, d, b, b, d, g, c, c, c, c, c,
            c, c, c, c, c, c, g, g, g, g, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "shield", name: "Shield", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Slime (16x16)
    
    static let slime: PremadeSpriteData = {
        let c = "clear"
        let g = "#5ac54f"  // green body
        let d = "#33984b"  // dark green
        let l = "#99e65f"  // light green
        let w = "#ffffff"  // eyes white
        let k = "#131313"  // eye pupil
        let s = "#1e6f50"  // shadow
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, l, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, l, g, l, c, c, c, c, c, c, c,
            c, c, c, c, c, l, g, g, g, l, c, c, c, c, c, c,
            c, c, c, c, l, g, g, g, g, g, l, c, c, c, c, c,
            c, c, c, l, g, g, g, g, g, g, g, l, c, c, c, c,
            c, c, c, d, g, g, g, g, g, g, g, d, c, c, c, c,
            c, c, d, g, g, w, k, g, g, w, k, g, d, c, c, c,
            c, c, d, g, g, w, k, g, g, w, k, g, d, c, c, c,
            c, c, d, g, g, g, g, g, g, g, g, g, d, c, c, c,
            c, c, d, d, g, g, g, g, g, g, g, d, d, c, c, c,
            c, c, c, d, d, d, d, d, d, d, d, d, c, c, c, c,
            c, c, c, c, s, s, s, s, s, s, s, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "slime", name: "Slime", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Gem (16x16)
    
    static let gem: PremadeSpriteData = {
        let c = "clear"
        let b = "#2ce8f5"  // bright cyan
        let m = "#0099db"  // medium blue
        let d = "#124e89"  // dark blue
        let w = "#ffffff"  // shine
        let k = "#0c2e44"  // deep shadow
        let l = "#94fdff"  // light highlight
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, d, d, d, d, d, d, c, c, c, c, c,
            c, c, c, c, d, m, m, m, m, m, m, d, c, c, c, c,
            c, c, c, d, m, b, l, m, m, b, m, m, d, c, c, c,
            c, c, d, m, b, l, w, b, m, m, m, m, m, d, c, c,
            c, c, d, d, d, d, d, d, d, d, d, d, d, d, c, c,
            c, c, c, d, m, b, l, b, m, m, m, m, d, c, c, c,
            c, c, c, c, d, m, b, m, m, m, m, d, c, c, c, c,
            c, c, c, c, c, d, m, m, m, m, d, c, c, c, c, c,
            c, c, c, c, c, c, d, m, m, d, c, c, c, c, c, c,
            c, c, c, c, c, c, c, d, d, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "gem", name: "Gem", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Cat (16x16)
    
    static let cat: PremadeSpriteData = {
        let c = "clear"
        let o = "#e07438"  // orange fur
        let d = "#8a4836"  // dark orange
        let w = "#ffffff"  // white
        let k = "#131313"  // black
        let p = "#f77622"  // pink nose area
        let n = "#ea323c"  // nose
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, d, d, c, c, c, c, c, c, c, c, d, d, c, c,
            c, c, d, o, d, c, c, c, c, c, c, d, o, d, c, c,
            c, c, d, o, o, d, d, d, d, d, d, o, o, d, c, c,
            c, c, c, d, o, o, o, o, o, o, o, o, d, c, c, c,
            c, c, c, d, o, o, o, o, o, o, o, o, d, c, c, c,
            c, c, c, d, o, w, k, o, o, w, k, o, d, c, c, c,
            c, c, c, d, o, w, k, o, o, w, k, o, d, c, c, c,
            c, c, c, d, o, o, o, n, n, o, o, o, d, c, c, c,
            c, c, c, d, o, o, p, o, o, p, o, o, d, c, c, c,
            c, c, c, c, d, o, o, o, o, o, o, d, c, c, c, c,
            c, c, c, c, c, d, d, d, d, d, d, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "cat", name: "Cat", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Dog (16x16)
    
    static let dog: PremadeSpriteData = {
        let c = "clear"
        let b = "#b86f50"  // brown fur
        let d = "#5d2c28"  // dark brown
        let w = "#ffffff"  // white
        let k = "#131313"  // black
        let n = "#131313"  // nose
        let t = "#e4a672"  // tan
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, d, d, d, c, c, c, c, c, c, d, d, d, c, c,
            c, d, b, b, b, d, c, c, c, c, d, b, b, b, d, c,
            c, d, b, b, b, d, d, d, d, d, d, b, b, b, d, c,
            c, c, d, b, b, b, b, b, b, b, b, b, b, d, c, c,
            c, c, d, b, b, b, b, b, b, b, b, b, b, d, c, c,
            c, c, d, b, w, k, b, b, b, w, k, b, b, d, c, c,
            c, c, d, b, w, k, b, b, b, w, k, b, b, d, c, c,
            c, c, d, b, b, b, b, n, n, b, b, b, b, d, c, c,
            c, c, d, b, b, t, t, t, t, t, t, b, b, d, c, c,
            c, c, c, d, b, t, t, t, t, t, t, b, d, c, c, c,
            c, c, c, c, d, d, b, b, b, b, d, d, c, c, c, c,
            c, c, c, c, c, c, d, d, d, d, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "dog", name: "Dog", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Arrow (16x16)
    
    static let arrow: PremadeSpriteData = {
        let c = "clear"
        let s = "#c0cbdc"  // silver tip
        let d = "#657392"  // dark tip
        let w = "#b86f50"  // wood shaft
        let k = "#5d2c28"  // dark wood
        let f = "#ea323c"  // red fletching
        let g = "#891e2b"  // dark red
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, s, d, c,
            c, c, c, c, c, c, c, c, c, c, c, c, s, s, c, c,
            c, c, c, c, c, c, c, c, c, c, c, d, s, c, c, c,
            c, c, c, c, c, c, c, c, c, c, w, k, c, c, c, c,
            c, c, c, c, c, c, c, c, c, w, k, c, c, c, c, c,
            c, c, c, c, c, c, c, c, w, k, c, c, c, c, c, c,
            c, c, c, c, c, c, c, w, k, c, c, c, c, c, c, c,
            c, c, c, c, c, c, w, k, c, c, c, c, c, c, c, c,
            c, c, c, c, c, w, k, c, c, c, c, c, c, c, c, c,
            c, c, c, c, w, k, c, c, c, c, c, c, c, c, c, c,
            c, c, c, w, k, c, c, c, c, c, c, c, c, c, c, c,
            c, c, w, k, c, c, c, c, c, c, c, c, c, c, c, c,
            c, f, g, c, c, c, c, c, c, c, c, c, c, c, c, c,
            f, f, g, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, f, g, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, g, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "arrow", name: "Arrow", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Chest (16x16)
    
    static let chest: PremadeSpriteData = {
        let c = "clear"
        let b = "#b86f50"  // brown wood
        let d = "#5d2c28"  // dark brown
        let g = "#edab50"  // gold trim
        let k = "#e07438"  // dark gold
        let l = "#ffc825"  // lock
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, d, d, d, d, d, d, d, d, d, d, c, c, c,
            c, c, d, b, b, b, g, g, g, g, b, b, b, d, c, c,
            c, c, d, b, b, b, g, b, b, g, b, b, b, d, c, c,
            c, c, d, b, b, b, g, b, b, g, b, b, b, d, c, c,
            c, c, d, g, g, g, g, g, g, g, g, g, g, d, c, c,
            c, c, d, b, b, b, b, l, l, b, b, b, b, d, c, c,
            c, c, d, b, b, b, l, k, k, l, b, b, b, d, c, c,
            c, c, d, b, b, b, b, l, l, b, b, b, b, d, c, c,
            c, c, d, b, b, b, b, b, b, b, b, b, b, d, c, c,
            c, c, d, d, d, d, d, d, d, d, d, d, d, d, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "chest", name: "Chest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Key (16x16)
    
    static let key: PremadeSpriteData = {
        let c = "clear"
        let g = "#edab50"  // gold
        let d = "#e07438"  // dark gold
        let k = "#8a4836"  // shadow
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, d, d, d, d, c, c, c, c, c, c,
            c, c, c, c, c, d, g, g, g, g, d, c, c, c, c, c,
            c, c, c, c, c, d, g, d, d, g, d, c, c, c, c, c,
            c, c, c, c, c, d, g, g, g, g, d, c, c, c, c, c,
            c, c, c, c, c, c, d, g, g, d, c, c, c, c, c, c,
            c, c, c, c, c, c, c, g, g, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, g, g, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, g, g, g, g, c, c, c, c, c,
            c, c, c, c, c, c, c, g, g, k, k, c, c, c, c, c,
            c, c, c, c, c, c, c, g, g, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, g, g, g, c, c, c, c, c, c,
            c, c, c, c, c, c, c, g, g, k, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "key", name: "Key", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Crown (16x16)
    
    static let crown: PremadeSpriteData = {
        let c = "clear"
        let g = "#edab50"  // gold
        let d = "#e07438"  // dark gold
        let r = "#ea323c"  // ruby red
        let b = "#0099db"  // sapphire blue
        let w = "#ffeb57"  // bright gold
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, w, c, c, c, w, w, c, c, c, w, c, c, c,
            c, c, c, g, w, c, c, w, w, c, c, w, g, c, c, c,
            c, c, c, g, g, w, c, g, g, c, w, g, g, c, c, c,
            c, c, c, g, g, g, g, g, g, g, g, g, g, c, c, c,
            c, c, c, g, g, r, g, g, g, g, b, g, g, c, c, c,
            c, c, c, g, g, r, g, g, g, g, b, g, g, c, c, c,
            c, c, c, g, g, g, g, r, r, g, g, g, g, c, c, c,
            c, c, c, d, d, d, d, d, d, d, d, d, d, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "crown", name: "Crown", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Bomb (16x16)
    
    static let bomb: PremadeSpriteData = {
        let c = "clear"
        let k = "#131313"  // black body
        let d = "#3d3d3d"  // dark gray
        let s = "#657392"  // shine
        let f = "#e07438"  // fuse orange
        let y = "#ffeb57"  // spark yellow
        let r = "#ea323c"  // spark red
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, r, y, c, c,
            c, c, c, c, c, c, c, c, c, c, c, y, r, c, c, c,
            c, c, c, c, c, c, c, c, c, c, f, f, c, c, c, c,
            c, c, c, c, c, c, c, c, c, f, f, c, c, c, c, c,
            c, c, c, c, c, d, d, d, d, d, d, c, c, c, c, c,
            c, c, c, c, d, k, k, k, k, k, k, d, c, c, c, c,
            c, c, c, d, k, k, k, k, k, k, k, k, d, c, c, c,
            c, c, c, d, k, s, s, k, k, k, k, k, d, c, c, c,
            c, c, c, d, k, s, k, k, k, k, k, k, d, c, c, c,
            c, c, c, d, k, k, k, k, k, k, k, k, d, c, c, c,
            c, c, c, d, k, k, k, k, k, k, k, k, d, c, c, c,
            c, c, c, c, d, k, k, k, k, k, k, d, c, c, c, c,
            c, c, c, c, c, d, d, d, d, d, d, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "bomb", name: "Bomb", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Cactus (16x16)
    
    static let cactus: PremadeSpriteData = {
        let c = "clear"
        let g = "#33984b"  // green
        let d = "#1e6f50"  // dark green
        let l = "#5ac54f"  // light green
        let b = "#b86f50"  // pot brown
        let k = "#8a4836"  // pot dark
        let y = "#edab50"  // pot rim
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, d, d, c, c, c, c, c, c, c,
            c, c, c, c, c, c, d, g, g, d, c, c, c, c, c, c,
            c, c, c, c, c, c, d, g, l, d, c, c, c, c, c, c,
            c, c, d, d, c, c, d, g, g, d, c, c, d, d, c, c,
            c, c, d, g, d, c, d, g, l, d, c, d, g, d, c, c,
            c, c, d, g, d, c, d, g, g, d, c, d, g, d, c, c,
            c, c, d, g, d, d, d, g, l, d, d, d, g, d, c, c,
            c, c, c, d, g, g, g, g, g, g, g, g, d, c, c, c,
            c, c, c, c, d, d, d, g, l, d, d, d, c, c, c, c,
            c, c, c, c, c, c, d, g, g, d, c, c, c, c, c, c,
            c, c, c, c, c, c, d, g, l, d, c, c, c, c, c, c,
            c, c, c, c, c, y, y, y, y, y, y, c, c, c, c, c,
            c, c, c, c, c, k, b, b, b, b, k, c, c, c, c, c,
            c, c, c, c, c, k, b, b, b, b, k, c, c, c, c, c,
            c, c, c, c, c, k, k, k, k, k, k, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "cactus", name: "Cactus", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Ghost (16x16)
    
    static let ghost: PremadeSpriteData = {
        let c = "clear"
        let w = "#ffffff"  // white body
        let g = "#c0cbdc"  // gray shadow
        let d = "#92a1b9"  // darker shadow
        let k = "#131313"  // eyes
        let m = "#657392"  // mouth
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, d, d, d, d, d, d, c, c, c, c, c,
            c, c, c, c, d, g, w, w, w, w, g, d, c, c, c, c,
            c, c, c, d, g, w, w, w, w, w, w, g, d, c, c, c,
            c, c, c, d, w, w, w, w, w, w, w, w, d, c, c, c,
            c, c, c, d, w, k, k, w, w, k, k, w, d, c, c, c,
            c, c, c, d, w, k, k, w, w, k, k, w, d, c, c, c,
            c, c, c, d, w, w, w, w, w, w, w, w, d, c, c, c,
            c, c, c, d, w, w, m, m, m, m, w, w, d, c, c, c,
            c, c, c, d, w, w, w, w, w, w, w, w, d, c, c, c,
            c, c, c, d, g, w, w, w, w, w, w, g, d, c, c, c,
            c, c, c, d, g, w, g, w, w, g, w, g, d, c, c, c,
            c, c, c, d, c, d, c, d, d, c, d, c, d, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "ghost", name: "Ghost", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Spaceship (16x16)
    
    static let spaceship: PremadeSpriteData = {
        let c = "clear"
        let s = "#c0cbdc"  // silver hull
        let d = "#657392"  // dark hull
        let b = "#0099db"  // blue window
        let r = "#ea323c"  // red accent
        let f = "#ffeb57"  // flame yellow
        let o = "#e07438"  // flame orange
        let k = "#424c6e"  // dark detail
        
        let grid: [String] = [
            c, c, c, c, c, c, c, d, d, c, c, c, c, c, c, c,
            c, c, c, c, c, c, d, s, s, d, c, c, c, c, c, c,
            c, c, c, c, c, d, s, s, s, s, d, c, c, c, c, c,
            c, c, c, c, c, d, s, b, b, s, d, c, c, c, c, c,
            c, c, c, c, c, d, s, b, b, s, d, c, c, c, c, c,
            c, c, c, c, d, s, s, s, s, s, s, d, c, c, c, c,
            c, c, c, c, d, s, s, k, k, s, s, d, c, c, c, c,
            c, c, c, d, s, s, s, s, s, s, s, s, d, c, c, c,
            c, c, r, d, s, s, s, s, s, s, s, s, d, r, c, c,
            c, r, r, d, s, s, s, k, k, s, s, s, d, r, r, c,
            c, r, d, d, d, s, s, s, s, s, s, d, d, d, r, c,
            c, c, c, c, d, d, d, d, d, d, d, d, c, c, c, c,
            c, c, c, c, c, c, d, o, o, d, c, c, c, c, c, c,
            c, c, c, c, c, c, o, f, f, o, c, c, c, c, c, c,
            c, c, c, c, c, c, c, f, f, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "spaceship", name: "Spaceship", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Avocado (16x16)
    
    static let avocado: PremadeSpriteData = {
        let c = "clear"
        let g = "#33984b"  // dark green skin
        let l = "#5ac54f"  // light green skin
        let y = "#e4d2aa"  // pale flesh
        let f = "#e4a672"  // flesh
        let p = "#b86f50"  // pit brown
        let d = "#5d2c28"  // pit dark
        let k = "#1e6f50"  // skin shadow
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, k, k, k, k, c, c, c, c, c, c,
            c, c, c, c, c, k, g, g, g, g, k, c, c, c, c, c,
            c, c, c, c, k, g, l, g, g, l, g, k, c, c, c, c,
            c, c, c, k, g, l, f, f, f, f, l, g, k, c, c, c,
            c, c, c, k, g, f, f, y, y, f, f, g, k, c, c, c,
            c, c, k, g, l, f, y, y, y, y, f, l, g, k, c, c,
            c, c, k, g, l, f, y, d, d, y, f, l, g, k, c, c,
            c, c, k, g, l, f, y, p, p, y, f, l, g, k, c, c,
            c, c, k, g, l, f, y, d, d, y, f, l, g, k, c, c,
            c, c, k, g, l, f, y, y, y, y, f, l, g, k, c, c,
            c, c, c, k, g, f, f, y, y, f, f, g, k, c, c, c,
            c, c, c, k, g, l, f, f, f, f, l, g, k, c, c, c,
            c, c, c, c, k, g, l, g, g, l, g, k, c, c, c, c,
            c, c, c, c, c, k, k, k, k, k, k, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "avocado", name: "Avocado", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    // MARK: - Flower (16x16) — Individual
    
    static let flower: PremadeSpriteData = {
        let c = "clear"
        let r = "#ea323c"   // red petals
        let p = "#f68187"   // pink petals
        let y = "#ffeb57"   // center
        let g = "#33984b"   // stem
        let l = "#5ac54f"   // leaf
        let d = "#1e6f50"   // dark green
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, r, r, r, c, c, c, c, c, c, c,
            c, c, c, c, c, r, r, p, r, r, c, c, c, c, c, c,
            c, c, c, c, r, r, p, y, y, r, r, c, c, c, c, c,
            c, c, c, r, r, p, y, y, y, y, p, r, c, c, c, c,
            c, c, c, r, r, p, y, y, y, y, p, r, c, c, c, c,
            c, c, c, c, r, r, p, y, y, r, r, c, c, c, c, c,
            c, c, c, c, c, r, r, p, r, r, c, c, c, c, c, c,
            c, c, c, c, c, c, c, g, g, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, g, g, c, l, l, c, c, c, c,
            c, c, c, c, c, c, c, g, g, l, l, c, c, c, c, c,
            c, c, c, c, l, l, c, g, g, c, c, c, c, c, c, c,
            c, c, c, c, c, l, l, g, g, c, c, c, c, c, c, c,
            c, c, c, c, c, c, d, g, g, d, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "flower", name: "Flower", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Dragon (16x16) — Individual
    
    static let dragon: PremadeSpriteData = {
        let c = "clear"
        let r = "#ea323c"   // red body
        let d = "#891e2b"   // dark red
        let o = "#e07438"   // orange belly
        let y = "#ffeb57"   // eye
        let k = "#131313"   // pupil
        let w = "#f68187"   // wing membrane
        let h = "#5d2c28"   // horn
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, h, c, h, c, c,
            c, c, c, c, c, c, c, c, c, c, d, r, d, r, d, c,
            c, c, c, c, c, c, c, c, c, d, r, r, r, r, r, d,
            c, c, c, c, c, c, c, c, c, d, r, y, k, r, r, d,
            c, c, d, w, w, c, c, c, d, r, r, r, r, r, d, c,
            c, d, w, w, w, w, c, d, r, r, r, r, r, d, c, c,
            c, c, d, w, w, w, d, r, o, o, r, r, d, c, c, c,
            c, c, c, d, w, d, r, o, o, o, r, d, c, c, c, c,
            c, c, c, c, d, r, r, o, o, r, r, r, d, c, c, c,
            c, c, c, c, c, d, r, r, r, r, d, r, r, d, c, c,
            c, c, c, c, c, c, d, d, d, d, c, d, d, d, c, c,
            c, c, c, c, c, d, r, d, d, r, d, c, c, c, c, c,
            c, c, c, c, c, d, r, c, c, r, d, c, c, c, c, c,
            c, c, c, c, d, d, d, c, c, d, d, d, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "dragon", name: "Dragon", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Treasure Map (16x16) — Individual
    
    static let treasureMap: PremadeSpriteData = {
        let c = "clear"
        let p = "#e4a672"   // parchment
        let d = "#b86f50"   // parchment dark
        let e = "#8a4836"   // edge/burnt
        let k = "#391f21"   // ink
        let r = "#ea323c"   // X marks the spot
        let b = "#0069aa"   // water/path blue
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, e, e, e, e, e, e, e, e, e, e, c, c, c,
            c, c, e, d, p, p, p, p, p, p, p, p, d, e, c, c,
            c, e, d, p, p, k, p, p, p, p, k, p, p, d, e, c,
            c, e, p, p, k, k, k, p, p, k, k, p, p, p, e, c,
            c, e, p, p, p, k, p, p, k, p, p, p, b, p, e, c,
            c, e, p, p, p, p, k, k, p, p, p, b, b, p, e, c,
            c, e, p, p, p, k, k, p, p, p, b, b, p, p, e, c,
            c, e, p, p, k, p, p, p, p, b, b, p, p, p, e, c,
            c, e, p, p, p, p, p, p, b, b, p, p, p, p, e, c,
            c, e, p, p, p, p, p, b, b, p, r, p, r, p, e, c,
            c, e, p, p, p, p, p, p, p, p, p, r, p, p, e, c,
            c, e, d, p, p, p, p, p, p, p, r, p, r, d, e, c,
            c, c, e, d, p, p, p, p, p, p, p, p, d, e, c, c,
            c, c, c, e, e, e, e, e, e, e, e, e, e, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "treasure_map", name: "Treasure Map", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Campfire (16x16) — Individual
    
    static let campfire: PremadeSpriteData = {
        let c = "clear"
        let r = "#ea323c"   // red flame
        let o = "#e07438"   // orange flame
        let y = "#ffeb57"   // yellow flame
        let w = "#ffc825"   // flame core
        let d = "#891e2b"   // dark flame
        let b = "#5d2c28"   // wood brown
        let k = "#391f21"   // wood dark
        let g = "#3d3d3d"   // stone
        let s = "#5d5d5d"   // stone light
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, y, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, y, w, y, c, c, c, c, c, c, c,
            c, c, c, c, c, y, w, w, w, y, c, c, c, c, c, c,
            c, c, c, c, c, o, w, w, w, y, o, c, c, c, c, c,
            c, c, c, c, o, r, w, y, w, o, r, c, c, c, c, c,
            c, c, c, c, r, o, y, y, o, r, r, o, c, c, c, c,
            c, c, c, c, d, r, o, o, r, d, o, r, c, c, c, c,
            c, c, c, c, c, d, r, r, d, r, d, c, c, c, c, c,
            c, c, c, c, c, c, d, d, d, d, c, c, c, c, c, c,
            c, c, c, b, k, b, b, k, b, b, k, b, k, c, c, c,
            c, c, c, k, b, k, b, b, k, b, k, b, b, c, c, c,
            c, c, s, g, k, b, k, k, b, k, b, k, g, s, c, c,
            c, c, g, s, g, s, g, g, s, g, s, g, s, g, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "campfire", name: "Campfire", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Anchor (16x16) — Individual
    
    static let anchor: PremadeSpriteData = {
        let c = "clear"
        let m = "#657392"   // metal
        let d = "#424c6e"   // metal dark
        let w = "#c0cbdc"   // metal light
        let k = "#2a2f4e"   // shadow
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, d, d, c, c, c, c, c, c, c,
            c, c, c, c, c, c, d, w, w, d, c, c, c, c, c, c,
            c, c, c, c, c, c, d, w, w, d, c, c, c, c, c, c,
            c, c, c, c, c, c, c, d, d, c, c, c, c, c, c, c,
            c, c, c, c, d, d, d, m, m, d, d, d, c, c, c, c,
            c, c, c, c, c, c, c, m, m, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, m, m, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, m, m, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, m, m, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, m, m, c, c, c, c, c, c, c,
            c, c, d, d, d, d, d, m, m, d, d, d, d, d, c, c,
            c, d, m, m, w, d, c, m, m, c, d, w, m, m, d, c,
            c, d, m, w, d, c, c, d, d, c, c, d, w, m, d, c,
            c, c, d, d, c, c, c, c, c, c, c, c, d, d, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "anchor", name: "Anchor", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
    
    // MARK: - Lantern (16x16) — Individual
    
    static let lantern: PremadeSpriteData = {
        let c = "clear"
        let m = "#657392"   // metal frame
        let d = "#424c6e"   // metal dark
        let y = "#ffeb57"   // glow yellow
        let o = "#ffc825"   // glow orange
        let g = "#edab50"   // glass warm
        let k = "#131313"   // hook
        
        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, k, k, c, c, c, c, c, c, c,
            c, c, c, c, c, c, k, c, c, k, c, c, c, c, c, c,
            c, c, c, c, c, c, c, d, d, c, c, c, c, c, c, c,
            c, c, c, c, c, d, d, m, m, d, d, c, c, c, c, c,
            c, c, c, c, c, d, g, g, g, g, d, c, c, c, c, c,
            c, c, c, c, c, d, g, o, y, g, d, c, c, c, c, c,
            c, c, c, c, c, d, g, y, y, g, d, c, c, c, c, c,
            c, c, c, c, c, d, g, y, o, g, d, c, c, c, c, c,
            c, c, c, c, c, d, g, o, y, g, d, c, c, c, c, c,
            c, c, c, c, c, d, g, g, g, g, d, c, c, c, c, c,
            c, c, c, c, c, d, d, m, m, d, d, c, c, c, c, c,
            c, c, c, c, c, c, c, d, d, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c,
        ]
        
        return PremadeSpriteData(id: "lantern", name: "Lantern", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid)
    }()
}

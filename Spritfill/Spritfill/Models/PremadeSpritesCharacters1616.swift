//
//  PremadeSpritesCharacters1616.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import Foundation

// MARK: - All 16x16 Character Trios

extension PremadeSprites {

    // MARK: - Knight

    static let knightIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#c0cbdc"
        let d = "#657392"
        let v = "#0069aa"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let g = "#edab50"
        let h = "#424c6e"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, o, a, a, a, o, c, c, c, c, c, c, // row 1
            c, c, c, c, o, a, a, a, a, a, o, c, c, c, c, c, // row 2
            c, c, c, c, o, a, v, v, v, a, o, c, c, c, c, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, c, c, c, // row 5
            c, c, c, c, o, d, a, a, a, d, o, c, c, c, c, c, // row 6
            c, c, c, o, d, a, g, a, a, a, d, o, c, c, c, c, // row 7
            c, c, c, o, h, a, a, a, a, a, h, o, c, c, c, c, // row 8
            c, c, o, s, o, d, a, a, a, d, o, s, o, c, c, c, // row 9
            c, c, c, c, c, o, d, d, d, o, c, c, a, c, c, c, // row 10
            c, c, c, c, c, o, h, c, h, o, c, c, a, c, c, c, // row 11
            c, c, c, c, c, o, h, c, h, o, c, c, d, c, c, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, g, c, c, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "knight_idle", name: "Knight — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Knight", groupOrder: 0)
    }()

    static let knightRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#c0cbdc"
        let d = "#657392"
        let v = "#0069aa"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let g = "#edab50"
        let h = "#424c6e"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 6
            c, c, c, c, c, c, c, c, c, c, c, a, a, a, c, c, // row 7
            c, c, c, o, a, a, a, o, c, c, c, c, a, d, c, c, // row 8
            c, c, o, a, v, v, v, a, o, c, c, c, g, c, c, c, // row 9
            c, c, o, s, k, k, k, k, o, c, c, c, c, c, c, c, // row 10
            c, c, c, o, s, s, s, o, c, c, c, c, c, c, c, c, // row 11
            c, o, d, a, g, a, a, a, d, h, o, c, c, c, c, c, // row 12
            c, o, h, a, a, a, a, a, a, h, b, b, o, c, c, c, // row 13
            c, c, o, o, d, d, d, d, o, o, b, b, o, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "knight_rest", name: "Knight — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Knight", groupOrder: 1)
    }()

    static let knightAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let a = "#c0cbdc"
        let d = "#657392"
        let v = "#0069aa"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let g = "#edab50"
        let h = "#424c6e"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, a, a, a, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, a, d, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, g, c, c, o, a, a, a, o, c, c, c, c, c, // row 3
            c, c, c, a, c, o, a, a, a, a, a, o, c, c, c, c, // row 4
            c, c, c, d, c, o, a, v, v, v, a, o, c, c, c, c, // row 5
            c, c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, // row 6
            c, c, c, c, c, c, o, s, s, s, o, c, c, c, c, c, // row 7
            c, c, c, c, c, o, d, a, g, a, d, o, c, c, c, c, // row 8
            c, c, c, c, o, h, a, a, a, a, a, h, o, c, c, c, // row 9
            c, c, c, c, o, s, o, d, d, d, o, s, o, c, c, c, // row 10
            c, c, c, c, c, c, o, h, c, h, o, c, c, c, c, c, // row 11
            c, c, c, c, c, c, o, h, c, h, o, c, c, c, c, c, // row 12
            c, c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, // row 13
            c, c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "knight_attack", name: "Knight — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Knight", groupOrder: 2)
    }()


    // MARK: - Wizard

    static let wizardIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let p = "#68386c"
        let r = "#9b5fc0"
        let w = "#ffffff"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let g = "#0ce6f2"
        let h = "#b6d53c"
        let d = "#493c2b"

        let grid: [String] = [
            c, c, c, c, c, c, c, o, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, o, r, o, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, o, r, r, r, o, c, c, c, c, c, c, // row 2
            c, c, c, c, o, r, r, r, r, r, o, c, c, c, c, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, c, c, c, // row 5
            c, c, c, c, o, p, r, r, r, p, o, c, c, c, c, c, // row 6
            c, c, c, o, p, r, r, r, r, r, p, o, c, c, d, c, // row 7
            c, c, c, o, p, r, r, r, r, r, p, o, c, c, d, c, // row 8
            c, c, o, s, o, p, r, r, r, p, o, s, o, c, d, c, // row 9
            c, c, c, c, c, o, p, p, p, o, c, c, c, c, d, c, // row 10
            c, c, c, c, c, o, p, c, p, o, c, c, c, c, d, c, // row 11
            c, c, c, c, c, o, p, c, p, o, c, c, c, c, d, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, d, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, g, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "wizard_idle", name: "Wizard — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Wizard", groupOrder: 0)
    }()

    static let wizardRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let p = "#68386c"
        let r = "#9b5fc0"
        let w = "#ffffff"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let g = "#0ce6f2"
        let h = "#b6d53c"
        let d = "#493c2b"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 6
            c, c, c, c, c, c, c, c, c, c, c, c, g, c, c, c, // row 7
            c, c, c, c, o, r, r, o, c, c, c, c, d, c, c, c, // row 8
            c, c, c, o, r, r, r, r, o, c, c, c, d, c, c, c, // row 9
            c, c, c, o, s, k, k, k, o, c, c, c, d, c, c, c, // row 10
            c, c, c, c, o, s, s, o, c, c, c, c, d, c, c, c, // row 11
            c, o, p, r, r, r, r, r, p, o, c, c, d, c, c, c, // row 12
            c, o, p, r, r, r, r, r, r, p, b, b, d, c, c, c, // row 13
            c, c, o, o, p, p, p, p, o, o, b, b, o, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "wizard_rest", name: "Wizard — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Wizard", groupOrder: 1)
    }()

    static let wizardAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let p = "#68386c"
        let r = "#9b5fc0"
        let w = "#ffffff"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let g = "#0ce6f2"
        let h = "#b6d53c"
        let d = "#493c2b"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, g, g, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, g, g, g, g, c, c, c, o, c, c, c, c, c, c, c, // row 2
            c, c, g, g, c, c, c, o, r, o, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, o, r, r, r, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, r, r, r, r, r, o, c, c, c, c, // row 5
            c, c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, // row 6
            c, c, c, c, c, c, o, s, s, s, o, c, c, c, c, c, // row 7
            c, c, c, c, c, o, p, r, r, r, p, o, c, c, c, c, // row 8
            c, c, c, c, o, p, r, r, r, r, r, p, o, c, c, c, // row 9
            c, c, c, o, s, o, p, r, r, p, o, s, o, c, c, c, // row 10
            c, c, c, c, c, c, o, p, c, p, o, c, c, c, c, c, // row 11
            c, c, c, c, c, c, o, p, c, p, o, c, c, c, c, c, // row 12
            c, c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, // row 13
            c, c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "wizard_attack", name: "Wizard — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Wizard", groupOrder: 2)
    }()


    // MARK: - Berserker

    static let berserkerIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let r = "#ea323c"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let d = "#657392"
        let a = "#c0cbdc"
        let h = "#5d2c28"
        let g = "#edab50"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, r, o, o, o, o, r, c, c, c, c, c, c, // row 1
            c, c, c, r, r, o, o, o, o, r, r, c, c, c, c, c, // row 2
            c, c, c, c, o, s, s, s, s, o, c, c, c, c, c, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, c, c, c, // row 5
            c, c, c, c, o, s, s, s, s, s, o, c, c, c, c, c, // row 6
            c, c, c, o, s, s, h, s, s, s, s, o, c, d, c, c, // row 7
            c, c, c, o, s, s, s, s, s, s, s, o, c, d, c, c, // row 8
            c, c, o, s, o, s, s, s, s, s, o, s, o, d, c, c, // row 9
            c, c, c, c, c, o, h, h, h, o, c, c, d, a, c, c, // row 10
            c, c, c, c, c, o, s, c, s, o, c, c, d, a, c, c, // row 11
            c, c, c, c, c, o, s, c, s, o, c, c, d, c, c, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, g, c, c, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "berserker_idle", name: "Berserker — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Berserker", groupOrder: 0)
    }()

    static let berserkerRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let r = "#ea323c"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let d = "#657392"
        let a = "#c0cbdc"
        let h = "#5d2c28"
        let g = "#edab50"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, d, a, c, c, c, // row 6
            c, c, c, c, c, c, c, c, c, c, c, d, a, c, c, c, // row 7
            c, c, c, r, r, o, o, o, r, r, c, d, c, c, c, c, // row 8
            c, c, c, c, o, s, s, s, s, o, c, d, c, c, c, c, // row 9
            c, c, c, c, o, s, k, k, k, o, c, g, c, c, c, c, // row 10
            c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, c, // row 11
            c, o, s, s, s, s, h, s, s, s, s, o, c, c, c, c, // row 12
            c, o, s, s, s, s, s, s, s, s, s, h, b, o, c, c, // row 13
            c, c, o, o, o, h, h, h, o, o, o, b, b, o, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "berserker_rest", name: "Berserker — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Berserker", groupOrder: 1)
    }()

    static let berserkerAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let r = "#ea323c"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let d = "#657392"
        let a = "#c0cbdc"
        let h = "#5d2c28"
        let g = "#edab50"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, d, a, a, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, d, a, a, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, d, c, c, c, c, // row 2
            c, c, c, c, r, o, o, o, o, r, c, d, c, c, c, c, // row 3
            c, c, c, r, r, o, o, o, o, r, r, g, c, c, c, c, // row 4
            c, c, c, c, o, s, s, s, s, o, c, c, c, c, c, c, // row 5
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, c, // row 6
            c, c, c, c, c, o, s, s, s, o, c, c, c, c, c, c, // row 7
            c, c, c, c, o, s, s, h, s, s, o, c, c, c, c, c, // row 8
            c, c, c, o, s, s, s, s, s, s, s, o, c, c, c, c, // row 9
            c, c, o, s, o, s, s, s, s, s, o, s, o, c, c, c, // row 10
            c, c, c, c, c, o, s, c, s, o, c, c, c, c, c, c, // row 11
            c, c, c, c, c, o, s, c, s, o, c, c, c, c, c, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 13
            c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "berserker_attack", name: "Berserker — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Berserker", groupOrder: 2)
    }()


    // MARK: - Samurai

    static let samuraiIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let r = "#891e2b"
        let a = "#ea323c"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let g = "#edab50"
        let d = "#657392"
        let w = "#c0cbdc"

        let grid: [String] = [
            c, c, c, c, c, c, g, g, g, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, o, r, r, r, o, c, c, c, c, c, c, // row 1
            c, c, c, c, o, r, a, a, a, r, o, c, c, c, c, c, // row 2
            c, c, c, c, o, r, r, r, r, r, o, c, c, c, c, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, c, c, c, // row 5
            c, c, c, c, o, r, a, a, a, r, o, c, c, c, c, c, // row 6
            c, c, c, o, r, a, a, a, a, a, r, o, c, w, c, c, // row 7
            c, c, c, o, r, a, a, a, a, a, r, o, c, w, c, c, // row 8
            c, c, o, s, o, r, a, a, a, r, o, s, o, w, c, c, // row 9
            c, c, c, c, c, o, r, r, r, o, c, c, c, w, c, c, // row 10
            c, c, c, c, c, o, r, c, r, o, c, c, c, d, c, c, // row 11
            c, c, c, c, c, o, r, c, r, o, c, c, c, g, c, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "samurai_idle", name: "Samurai — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Samurai", groupOrder: 0)
    }()

    static let samuraiRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let r = "#891e2b"
        let a = "#ea323c"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let g = "#edab50"
        let d = "#657392"
        let w = "#c0cbdc"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, w, w, w, c, c, // row 6
            c, c, c, c, c, g, g, g, c, c, c, c, w, d, c, c, // row 7
            c, c, c, c, o, r, a, r, o, c, c, c, g, c, c, c, // row 8
            c, c, c, o, r, r, r, r, r, o, c, c, c, c, c, c, // row 9
            c, c, c, o, s, k, k, k, k, o, c, c, c, c, c, c, // row 10
            c, c, c, c, o, s, s, s, o, c, c, c, c, c, c, c, // row 11
            c, o, r, a, a, a, a, a, a, r, o, c, c, c, c, c, // row 12
            c, o, r, a, a, a, a, a, a, r, b, b, o, c, c, c, // row 13
            c, c, o, o, r, r, r, r, o, o, b, b, o, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "samurai_rest", name: "Samurai — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Samurai", groupOrder: 1)
    }()

    static let samuraiAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let r = "#891e2b"
        let a = "#ea323c"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let g = "#edab50"
        let d = "#657392"
        let w = "#c0cbdc"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, w, w, w, w, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, w, d, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, g, c, c, c, g, g, g, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, o, r, a, r, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, r, a, a, a, r, o, c, c, c, c, // row 5
            c, c, c, c, c, o, r, r, r, r, r, o, c, c, c, c, // row 6
            c, c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, // row 7
            c, c, c, c, c, c, o, s, s, s, o, c, c, c, c, c, // row 8
            c, c, c, c, c, o, r, a, a, a, r, o, c, c, c, c, // row 9
            c, c, c, c, o, r, a, a, a, a, a, r, o, c, c, c, // row 10
            c, c, c, o, s, o, r, a, a, r, o, s, o, c, c, c, // row 11
            c, c, c, c, c, c, o, r, c, r, o, c, c, c, c, c, // row 12
            c, c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, // row 13
            c, c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "samurai_attack", name: "Samurai — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Samurai", groupOrder: 2)
    }()


    // MARK: - Bowman

    static let bowmanIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#33984b"
        let a = "#5ac54f"
        let d = "#1e6f50"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#5d2c28"
        let g = "#edab50"
        let f = "#f68187"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, o, h, h, h, o, c, c, c, c, c, c, // row 1
            c, c, c, c, o, h, a, a, a, h, o, c, c, c, c, c, // row 2
            c, c, c, c, o, h, h, h, h, h, o, c, c, c, c, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, c, c, c, // row 5
            c, c, c, c, o, h, a, a, a, h, o, c, c, c, c, c, // row 6
            c, c, c, o, h, a, a, a, a, a, h, o, c, w, c, c, // row 7
            c, c, c, o, h, a, a, a, a, a, h, o, c, w, c, c, // row 8
            c, c, o, s, o, h, a, a, a, h, o, s, o, w, c, c, // row 9
            c, c, c, c, c, o, h, h, h, o, c, c, c, w, c, c, // row 10
            c, c, c, c, c, o, h, c, h, o, c, c, c, w, c, c, // row 11
            c, c, c, c, c, o, h, c, h, o, c, c, c, w, c, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "bowman_idle", name: "Bowman — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Bowman", groupOrder: 0)
    }()

    static let bowmanRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#33984b"
        let a = "#5ac54f"
        let d = "#1e6f50"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#5d2c28"
        let g = "#edab50"
        let f = "#f68187"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 6
            c, c, c, c, c, c, c, c, c, c, c, w, w, w, c, c, // row 7
            c, c, c, c, o, h, h, h, o, c, c, c, w, c, c, c, // row 8
            c, c, c, o, h, a, a, a, h, o, c, c, w, c, c, c, // row 9
            c, c, c, o, s, k, k, k, k, o, c, c, c, c, c, c, // row 10
            c, c, c, c, o, s, s, s, o, c, c, c, c, c, c, c, // row 11
            c, o, h, a, a, a, a, a, a, h, o, c, c, c, c, c, // row 12
            c, o, h, a, a, a, a, a, a, h, b, b, o, c, c, c, // row 13
            c, c, o, o, h, h, h, h, o, o, b, b, o, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "bowman_rest", name: "Bowman — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Bowman", groupOrder: 1)
    }()

    static let bowmanAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#33984b"
        let a = "#5ac54f"
        let d = "#1e6f50"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#5d2c28"
        let g = "#edab50"
        let f = "#f68187"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, w, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, w, c, c, c, // row 2
            c, c, c, c, c, o, h, h, h, o, c, w, c, c, c, c, // row 3
            c, c, c, c, o, h, a, a, a, h, w, c, c, c, c, c, // row 4
            c, c, c, c, o, h, h, h, h, h, o, g, g, g, g, f, // row 5
            c, c, c, c, o, s, e, k, e, k, w, c, c, c, c, c, // row 6
            c, c, c, c, c, o, s, s, s, o, c, w, c, c, c, c, // row 7
            c, c, c, c, o, h, a, a, a, h, o, c, w, c, c, c, // row 8
            c, c, c, o, h, a, a, a, a, a, h, o, c, w, c, c, // row 9
            c, c, o, s, o, h, a, a, a, h, o, s, o, c, c, c, // row 10
            c, c, c, c, c, o, h, c, h, o, c, c, c, c, c, c, // row 11
            c, c, c, c, c, o, h, c, h, o, c, c, c, c, c, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 13
            c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "bowman_attack", name: "Bowman — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Bowman", groupOrder: 2)
    }()


    // MARK: - Viking

    static let vikingIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#c0cbdc"
        let a = "#657392"
        let d = "#424c6e"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#edab50"
        let g = "#5d2c28"
        let f = "#f6757a"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, w, o, h, h, h, o, w, c, c, c, c, c, // row 1
            c, c, c, c, w, o, h, h, h, o, w, c, c, c, c, c, // row 2
            c, c, c, c, o, h, h, h, h, h, o, c, c, c, c, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, f, s, s, o, c, c, c, c, c, c, // row 5
            c, c, c, c, o, a, d, d, d, a, o, c, c, c, c, c, // row 6
            c, c, c, o, a, d, a, a, a, d, a, o, c, h, c, c, // row 7
            c, c, c, o, d, a, a, a, a, a, d, o, c, h, c, c, // row 8
            c, c, o, s, o, a, d, d, d, a, o, s, o, h, c, c, // row 9
            c, c, c, c, c, o, a, a, a, o, c, c, h, a, c, c, // row 10
            c, c, c, c, c, o, a, c, a, o, c, c, h, a, c, c, // row 11
            c, c, c, c, c, o, a, c, a, o, c, c, g, c, c, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, w, c, c, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "viking_idle", name: "Viking — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Viking", groupOrder: 0)
    }()

    static let vikingRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#c0cbdc"
        let a = "#657392"
        let d = "#424c6e"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#edab50"
        let g = "#5d2c28"
        let f = "#f6757a"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, h, a, a, c, c, c, // row 6
            c, c, c, w, o, h, h, o, w, c, h, a, c, c, c, c, // row 7
            c, c, c, w, o, h, h, o, w, c, g, c, c, c, c, c, // row 8
            c, c, c, c, o, s, s, s, o, c, w, c, c, c, c, c, // row 9
            c, c, c, c, o, s, k, k, o, c, c, c, c, c, c, c, // row 10
            c, c, c, c, c, o, f, o, c, c, c, c, c, c, c, c, // row 11
            c, o, a, d, a, d, d, d, a, d, o, c, c, c, c, c, // row 12
            c, o, d, a, a, a, a, a, a, d, b, b, o, c, c, c, // row 13
            c, c, o, o, a, a, a, a, o, o, b, b, o, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "viking_rest", name: "Viking — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Viking", groupOrder: 1)
    }()

    static let vikingAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#c0cbdc"
        let a = "#657392"
        let d = "#424c6e"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#edab50"
        let g = "#5d2c28"
        let f = "#f6757a"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, h, a, a, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, h, a, a, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, h, c, c, c, c, // row 2
            c, c, c, c, w, o, h, h, h, o, w, g, c, c, c, c, // row 3
            c, c, c, c, w, o, h, h, h, o, w, w, c, c, c, c, // row 4
            c, c, c, c, o, h, h, h, h, h, o, c, c, c, c, c, // row 5
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, c, // row 6
            c, c, c, c, c, o, f, s, s, o, c, c, c, c, c, c, // row 7
            c, c, c, c, o, a, d, d, d, a, o, c, c, c, c, c, // row 8
            c, c, c, o, d, a, a, a, a, a, d, o, c, c, c, c, // row 9
            c, c, o, s, o, a, d, d, d, a, o, s, o, c, c, c, // row 10
            c, c, c, c, c, o, a, c, a, o, c, c, c, c, c, c, // row 11
            c, c, c, c, c, o, a, c, a, o, c, c, c, c, c, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 13
            c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "viking_attack", name: "Viking — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Viking", groupOrder: 2)
    }()


    // MARK: - Guandao

    static let guandaoIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#edab50"
        let a = "#ea323c"
        let d = "#891e2b"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#5d2c28"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, o, o, o, o, o, o, c, w, w, c, c, // row 1
            c, c, c, c, o, a, h, h, h, a, o, c, c, w, c, c, // row 2
            c, c, c, c, o, d, d, d, d, d, o, c, c, w, c, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, w, c, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, w, c, c, // row 5
            c, c, c, c, o, a, d, d, d, a, o, c, c, w, c, c, // row 6
            c, c, c, o, a, d, a, a, a, d, a, o, c, w, c, c, // row 7
            c, c, c, o, d, a, a, a, a, a, d, o, c, w, c, c, // row 8
            c, c, o, s, o, d, a, a, a, d, o, s, o, w, c, c, // row 9
            c, c, c, c, c, o, d, d, d, o, c, c, c, w, c, c, // row 10
            c, c, c, c, c, o, d, c, d, o, c, c, c, w, c, c, // row 11
            c, c, c, c, c, o, d, c, d, o, c, c, c, w, c, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, w, c, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, g, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "guandao_idle", name: "Guandao — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Guandao", groupOrder: 0)
    }()

    static let guandaoRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#edab50"
        let a = "#ea323c"
        let d = "#891e2b"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#5d2c28"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 6
            c, w, w, w, w, w, w, w, w, w, w, w, w, w, g, c, // row 7
            c, c, c, c, o, d, h, h, h, d, o, c, c, c, c, c, // row 8
            c, c, c, o, o, d, s, s, s, d, o, c, c, c, c, c, // row 9
            c, c, c, c, o, s, k, k, k, o, c, c, c, c, c, c, // row 10
            c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, c, // row 11
            c, o, a, d, a, a, a, a, a, a, d, a, o, c, c, c, // row 12
            c, o, d, a, a, a, a, a, a, a, a, d, o, b, o, c, // row 13
            c, c, o, o, d, d, d, d, d, d, o, o, b, o, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "guandao_rest", name: "Guandao — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Guandao", groupOrder: 1)
    }()

    static let guandaoAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#edab50"
        let a = "#ea323c"
        let d = "#891e2b"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#5d2c28"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, w, w, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, w, w, w, w, o, h, h, h, h, o, c, c, c, c, c, // row 3
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, e, k, e, o, c, c, c, c, c, // row 5
            c, c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, // row 6
            c, c, c, c, c, o, d, a, a, a, d, o, c, c, c, c, // row 7
            c, c, c, c, o, d, a, a, a, a, a, d, o, c, c, c, // row 8
            c, c, c, o, s, o, d, a, a, a, d, o, s, o, c, c, // row 9
            c, c, c, c, c, c, o, d, d, d, o, c, c, c, c, c, // row 10
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 11
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 12
            c, c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, // row 13
            c, c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "guandao_attack", name: "Guandao — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Guandao", groupOrder: 2)
    }()


    // MARK: - Sorcerer

    static let sorcererIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#391f21"
        let a = "#9b5fc0"
        let d = "#68386c"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#ea323c"
        let g = "#891e2b"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c, // row 1
            c, c, c, c, o, a, h, h, h, a, o, c, c, c, w, c, // row 2
            c, c, c, c, o, d, d, d, d, d, o, c, c, w, w, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, g, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, c, g, c, // row 5
            c, c, c, c, o, a, d, d, d, a, o, c, c, c, g, c, // row 6
            c, c, c, o, a, d, a, a, a, d, a, o, c, c, g, c, // row 7
            c, c, c, o, d, a, a, a, a, a, d, o, c, c, g, c, // row 8
            c, c, o, s, o, d, a, a, a, d, o, s, o, c, g, c, // row 9
            c, c, c, c, c, o, d, d, d, o, c, c, c, c, g, c, // row 10
            c, c, c, c, c, o, d, c, d, o, c, c, c, c, g, c, // row 11
            c, c, c, c, c, o, d, c, d, o, c, c, c, c, g, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, g, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, g, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "sorcerer_idle", name: "Sorcerer — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Sorcerer", groupOrder: 0)
    }()

    static let sorcererRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#391f21"
        let a = "#9b5fc0"
        let d = "#68386c"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#ea323c"
        let g = "#891e2b"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 6
            c, w, g, g, g, g, g, g, g, g, g, g, g, w, c, c, // row 7
            c, c, c, c, o, d, h, h, h, d, o, c, c, c, c, c, // row 8
            c, c, c, o, o, d, s, s, s, d, o, c, c, c, c, c, // row 9
            c, c, c, c, o, s, k, k, k, o, c, c, c, c, c, c, // row 10
            c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, c, // row 11
            c, o, a, d, a, a, a, a, a, a, d, a, o, c, c, c, // row 12
            c, o, d, a, a, a, a, a, a, a, a, d, o, b, o, c, // row 13
            c, c, o, o, d, d, d, d, d, d, o, o, b, o, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "sorcerer_rest", name: "Sorcerer — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Sorcerer", groupOrder: 1)
    }()

    static let sorcererAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#391f21"
        let a = "#9b5fc0"
        let d = "#68386c"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#ea323c"
        let g = "#891e2b"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, w, w, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, w, w, w, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, w, c, o, h, h, h, h, o, c, c, c, c, c, // row 3
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, e, k, e, o, c, c, c, c, c, // row 5
            c, c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, // row 6
            c, c, c, c, c, o, d, a, a, a, d, o, c, c, c, c, // row 7
            c, c, c, c, o, d, a, a, a, a, a, d, o, c, c, c, // row 8
            c, c, c, o, s, o, d, a, a, a, d, o, s, o, c, c, // row 9
            c, c, c, c, c, c, o, d, d, d, o, c, c, c, c, c, // row 10
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 11
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 12
            c, c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, // row 13
            c, c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "sorcerer_attack", name: "Sorcerer — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Sorcerer", groupOrder: 2)
    }()


    // MARK: - Cleric

    static let clericIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#edab50"
        let a = "#ffffff"
        let d = "#c0cbdc"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#b6d53c"
        let g = "#5d2c28"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c, // row 1
            c, c, c, c, o, a, h, h, h, a, o, c, c, w, w, c, // row 2
            c, c, c, c, o, d, d, d, d, d, o, c, c, c, w, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, g, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, c, g, c, // row 5
            c, c, c, c, o, a, d, d, d, a, o, c, c, c, g, c, // row 6
            c, c, c, o, a, d, a, a, a, d, a, o, c, c, g, c, // row 7
            c, c, c, o, d, a, a, a, a, a, d, o, c, c, g, c, // row 8
            c, c, o, s, o, d, a, a, a, d, o, s, o, c, g, c, // row 9
            c, c, c, c, c, o, d, d, d, o, c, c, c, c, g, c, // row 10
            c, c, c, c, c, o, d, c, d, o, c, c, c, c, g, c, // row 11
            c, c, c, c, c, o, d, c, d, o, c, c, c, c, g, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, g, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, g, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "cleric_idle", name: "Cleric — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Cleric", groupOrder: 0)
    }()

    static let clericRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#edab50"
        let a = "#ffffff"
        let d = "#c0cbdc"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#b6d53c"
        let g = "#5d2c28"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 6
            c, w, g, g, g, g, g, g, g, g, g, g, g, w, c, c, // row 7
            c, c, c, c, o, d, h, h, h, d, o, c, c, c, c, c, // row 8
            c, c, c, o, o, d, s, s, s, d, o, c, c, c, c, c, // row 9
            c, c, c, c, o, s, k, k, k, o, c, c, c, c, c, c, // row 10
            c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, c, // row 11
            c, o, a, d, a, a, a, a, a, a, d, a, o, c, c, c, // row 12
            c, o, d, a, a, a, a, a, a, a, a, d, o, b, o, c, // row 13
            c, c, o, o, d, d, d, d, d, d, o, o, b, o, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "cleric_rest", name: "Cleric — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Cleric", groupOrder: 1)
    }()

    static let clericAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#edab50"
        let a = "#ffffff"
        let d = "#c0cbdc"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#b6d53c"
        let g = "#5d2c28"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, w, w, w, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, w, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, o, h, h, h, h, o, c, c, c, c, c, // row 3
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, e, k, e, o, c, c, c, c, c, // row 5
            c, c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, // row 6
            c, c, c, c, c, o, d, a, a, a, d, o, c, c, c, c, // row 7
            c, c, c, c, o, d, a, a, a, a, a, d, o, c, c, c, // row 8
            c, c, c, o, s, o, d, a, a, a, d, o, s, o, c, c, // row 9
            c, c, c, c, c, c, o, d, d, d, o, c, c, c, c, c, // row 10
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 11
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 12
            c, c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, // row 13
            c, c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "cleric_attack", name: "Cleric — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Cleric", groupOrder: 2)
    }()


    // MARK: - Priest

    static let priestIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#c0cbdc"
        let a = "#fff7a0"
        let d = "#ffd541"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#5d2c28"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c, // row 1
            c, c, c, c, o, a, h, h, h, a, o, c, c, w, w, w, // row 2
            c, c, c, c, o, d, d, d, d, d, o, c, c, c, w, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, g, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, c, g, c, // row 5
            c, c, c, c, o, a, d, d, d, a, o, c, c, c, g, c, // row 6
            c, c, c, o, a, d, a, a, a, d, a, o, c, c, g, c, // row 7
            c, c, c, o, d, a, a, a, a, a, d, o, c, c, g, c, // row 8
            c, c, o, s, o, d, a, a, a, d, o, s, o, c, g, c, // row 9
            c, c, c, c, c, o, d, d, d, o, c, c, c, c, g, c, // row 10
            c, c, c, c, c, o, d, c, d, o, c, c, c, c, g, c, // row 11
            c, c, c, c, c, o, d, c, d, o, c, c, c, c, g, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, g, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, g, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "priest_idle", name: "Priest — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Priest", groupOrder: 0)
    }()

    static let priestRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#c0cbdc"
        let a = "#fff7a0"
        let d = "#ffd541"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#5d2c28"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 6
            c, w, g, g, g, g, g, g, g, g, g, g, g, w, c, c, // row 7
            c, c, c, c, o, d, h, h, h, d, o, c, c, c, c, c, // row 8
            c, c, c, o, o, d, s, s, s, d, o, c, c, c, c, c, // row 9
            c, c, c, c, o, s, k, k, k, o, c, c, c, c, c, c, // row 10
            c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, c, // row 11
            c, o, a, d, a, a, a, a, a, a, d, a, o, c, c, c, // row 12
            c, o, d, a, a, a, a, a, a, a, a, d, o, b, o, c, // row 13
            c, c, o, o, d, d, d, d, d, d, o, o, b, o, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "priest_rest", name: "Priest — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Priest", groupOrder: 1)
    }()

    static let priestAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#c0cbdc"
        let a = "#fff7a0"
        let d = "#ffd541"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#5d2c28"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, w, w, w, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, w, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, o, h, h, h, h, o, c, c, c, c, c, // row 3
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, e, k, e, o, c, c, c, c, c, // row 5
            c, c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, // row 6
            c, c, c, c, c, o, d, a, a, a, d, o, c, c, c, c, // row 7
            c, c, c, c, o, d, a, a, a, a, a, d, o, c, c, c, // row 8
            c, c, c, o, s, o, d, a, a, a, d, o, s, o, c, c, // row 9
            c, c, c, c, c, c, o, d, d, d, o, c, c, c, c, c, // row 10
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 11
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 12
            c, c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, // row 13
            c, c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "priest_attack", name: "Priest — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Priest", groupOrder: 2)
    }()


    // MARK: - Warrior

    static let warriorIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#5d2c28"
        let a = "#bf6f4a"
        let d = "#5d2c28"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#edab50"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c, // row 1
            c, c, c, c, o, a, h, h, h, a, o, c, c, c, c, c, // row 2
            c, c, c, c, o, d, d, d, d, d, o, c, c, c, c, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, c, c, c, // row 5
            c, c, c, c, o, a, d, d, d, a, o, c, c, c, c, c, // row 6
            c, a, d, o, a, d, a, a, a, d, a, o, c, w, c, c, // row 7
            c, a, d, o, d, a, a, a, a, a, d, o, c, w, c, c, // row 8
            c, a, d, s, o, d, a, a, a, d, o, s, o, w, c, c, // row 9
            c, c, c, c, c, o, d, d, d, o, c, c, c, w, c, c, // row 10
            c, c, c, c, c, o, d, c, d, o, c, c, c, w, c, c, // row 11
            c, c, c, c, c, o, d, c, d, o, c, c, c, w, c, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, g, c, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "warrior_idle", name: "Warrior — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Warrior", groupOrder: 0)
    }()

    static let warriorRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#5d2c28"
        let a = "#bf6f4a"
        let d = "#5d2c28"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#edab50"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 6
            c, c, c, w, w, w, w, w, w, w, w, g, c, c, c, c, // row 7
            c, c, c, c, o, d, h, h, h, d, o, c, c, c, c, c, // row 8
            c, c, c, o, o, d, s, s, s, d, o, c, c, c, c, c, // row 9
            c, c, c, c, o, s, k, k, k, o, c, c, c, c, c, c, // row 10
            c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, c, // row 11
            c, o, a, d, a, a, a, a, a, a, d, a, o, c, c, c, // row 12
            c, o, d, a, a, a, a, a, a, a, a, d, o, b, o, c, // row 13
            c, c, o, o, d, d, d, d, d, d, o, o, b, o, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "warrior_rest", name: "Warrior — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Warrior", groupOrder: 1)
    }()

    static let warriorAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#5d2c28"
        let a = "#bf6f4a"
        let d = "#5d2c28"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#edab50"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, w, w, w, o, h, h, h, h, o, c, c, c, c, c, // row 3
            c, c, c, c, g, o, d, d, d, d, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, e, k, e, o, c, c, c, c, c, // row 5
            c, c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, // row 6
            c, c, c, c, c, o, d, a, a, a, d, o, c, c, c, c, // row 7
            c, c, a, d, o, d, a, a, a, a, a, d, o, c, c, c, // row 8
            c, c, a, d, s, o, d, a, a, a, d, o, s, o, c, c, // row 9
            c, c, c, c, c, c, o, d, d, d, o, c, c, c, c, c, // row 10
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 11
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 12
            c, c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, // row 13
            c, c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "warrior_attack", name: "Warrior — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Warrior", groupOrder: 2)
    }()


    // MARK: - Spearman

    static let spearmanIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#424c6e"
        let a = "#3c9f9c"
        let d = "#0069aa"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#5d2c28"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, o, o, o, o, o, o, c, c, w, c, c, // row 1
            c, c, c, c, o, a, h, h, h, a, o, c, c, w, c, c, // row 2
            c, c, c, c, o, d, d, d, d, d, o, c, c, w, c, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, w, c, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, w, c, c, // row 5
            c, c, c, c, o, a, d, d, d, a, o, c, c, w, c, c, // row 6
            c, c, c, o, a, d, a, a, a, d, a, o, c, w, c, c, // row 7
            c, c, c, o, d, a, a, a, a, a, d, o, c, w, c, c, // row 8
            c, c, o, s, o, d, a, a, a, d, o, s, o, w, c, c, // row 9
            c, c, c, c, c, o, d, d, d, o, c, c, c, w, c, c, // row 10
            c, c, c, c, c, o, d, c, d, o, c, c, c, w, c, c, // row 11
            c, c, c, c, c, o, d, c, d, o, c, c, c, w, c, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, w, c, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, g, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "spearman_idle", name: "Spearman — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Spearman", groupOrder: 0)
    }()

    static let spearmanRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#424c6e"
        let a = "#3c9f9c"
        let d = "#0069aa"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#5d2c28"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 6
            c, w, w, w, w, w, w, w, w, w, w, w, w, w, g, c, // row 7
            c, c, c, c, o, d, h, h, h, d, o, c, c, c, c, c, // row 8
            c, c, c, o, o, d, s, s, s, d, o, c, c, c, c, c, // row 9
            c, c, c, c, o, s, k, k, k, o, c, c, c, c, c, c, // row 10
            c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, c, // row 11
            c, o, a, d, a, a, a, a, a, a, d, a, o, c, c, c, // row 12
            c, o, d, a, a, a, a, a, a, a, a, d, o, b, o, c, // row 13
            c, c, o, o, d, d, d, d, d, d, o, o, b, o, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "spearman_rest", name: "Spearman — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Spearman", groupOrder: 1)
    }()

    static let spearmanAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#424c6e"
        let a = "#3c9f9c"
        let d = "#0069aa"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#5d2c28"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, w, w, w, w, o, h, h, h, h, o, c, c, c, c, c, // row 3
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, e, k, e, o, c, c, c, c, c, // row 5
            c, c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, // row 6
            c, c, c, c, c, o, d, a, a, a, d, o, c, c, c, c, // row 7
            c, c, c, c, o, d, a, a, a, a, a, d, o, c, c, c, // row 8
            c, c, c, o, s, o, d, a, a, a, d, o, s, o, c, c, // row 9
            c, c, c, c, c, c, o, d, d, d, o, c, c, c, c, c, // row 10
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 11
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 12
            c, c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, // row 13
            c, c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "spearman_attack", name: "Spearman — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Spearman", groupOrder: 2)
    }()


    // MARK: - Assassin

    static let assassinIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#131313"
        let a = "#424c6e"
        let d = "#391f21"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#657392"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c, // row 1
            c, c, c, c, o, a, h, h, h, a, o, c, c, c, c, c, // row 2
            c, c, c, c, o, d, d, d, d, d, o, c, c, c, c, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, c, c, c, // row 5
            c, c, c, c, o, a, d, d, d, a, o, c, c, c, c, c, // row 6
            c, c, c, o, a, d, a, a, a, d, a, o, c, c, c, c, // row 7
            c, c, c, o, d, a, a, a, a, a, d, o, c, c, c, c, // row 8
            c, c, w, s, o, d, a, a, a, d, o, s, o, w, c, c, // row 9
            c, c, w, c, c, o, d, d, d, o, c, c, c, w, c, c, // row 10
            c, c, w, c, c, o, d, c, d, o, c, c, c, w, c, c, // row 11
            c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "assassin_idle", name: "Assassin — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Assassin", groupOrder: 0)
    }()

    static let assassinRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#131313"
        let a = "#424c6e"
        let d = "#391f21"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#657392"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 6
            c, c, c, c, c, w, w, w, w, c, c, c, c, c, c, c, // row 7
            c, c, c, c, o, d, h, h, h, d, o, c, c, c, c, c, // row 8
            c, c, c, o, o, d, s, s, s, d, o, c, c, c, c, c, // row 9
            c, c, c, c, o, s, k, k, k, o, c, c, c, c, c, c, // row 10
            c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, c, // row 11
            c, o, a, d, a, a, a, a, a, a, d, a, o, c, c, c, // row 12
            c, o, d, a, a, a, a, a, a, a, a, d, o, b, o, c, // row 13
            c, c, o, o, d, d, d, d, d, d, o, o, b, o, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "assassin_rest", name: "Assassin — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Assassin", groupOrder: 1)
    }()

    static let assassinAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#131313"
        let a = "#424c6e"
        let d = "#391f21"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#c0cbdc"
        let g = "#657392"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, o, h, h, h, h, o, c, c, c, c, c, // row 3
            c, c, c, c, c, o, d, d, d, d, o, c, c, c, c, c, // row 4
            c, c, c, w, w, o, s, e, k, e, o, c, c, c, c, c, // row 5
            c, c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, // row 6
            c, c, c, c, c, o, d, a, a, a, d, o, c, c, c, c, // row 7
            c, c, c, c, o, d, a, a, a, a, a, d, o, w, w, c, // row 8
            c, c, c, o, s, o, d, a, a, a, d, o, s, o, c, c, // row 9
            c, c, c, c, c, c, o, d, d, d, o, c, c, c, c, c, // row 10
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 11
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 12
            c, c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, // row 13
            c, c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "assassin_attack", name: "Assassin — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Assassin", groupOrder: 2)
    }()


    // MARK: - Paladin

    static let paladinIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#edab50"
        let a = "#ffd541"
        let d = "#edab50"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#ffffff"
        let g = "#edab50"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c, // row 1
            c, c, c, c, o, a, h, h, h, a, o, c, c, c, c, c, // row 2
            c, c, c, c, o, d, d, d, d, d, o, c, c, c, c, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, w, c, c, // row 5
            c, c, c, c, o, a, d, d, d, a, o, c, c, w, c, c, // row 6
            c, c, c, o, a, d, a, a, a, d, a, o, c, w, c, c, // row 7
            c, c, c, o, d, a, a, a, a, a, d, o, c, w, c, c, // row 8
            c, c, o, s, o, d, a, a, a, d, o, s, o, w, c, c, // row 9
            c, c, c, c, c, o, d, d, d, o, c, c, c, w, c, c, // row 10
            c, c, c, c, c, o, d, c, d, o, c, c, c, w, c, c, // row 11
            c, c, c, c, c, o, d, c, d, o, c, c, g, w, g, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, g, c, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "paladin_idle", name: "Paladin — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Paladin", groupOrder: 0)
    }()

    static let paladinRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#edab50"
        let a = "#ffd541"
        let d = "#edab50"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#ffffff"
        let g = "#edab50"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 6
            c, g, w, w, w, w, w, w, w, w, w, w, g, c, c, c, // row 7
            c, c, c, c, o, d, h, h, h, d, o, c, c, c, c, c, // row 8
            c, c, c, o, o, d, s, s, s, d, o, c, c, c, c, c, // row 9
            c, c, c, c, o, s, k, k, k, o, c, c, c, c, c, c, // row 10
            c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, c, // row 11
            c, o, a, d, a, a, a, a, a, a, d, a, o, c, c, c, // row 12
            c, o, d, a, a, a, a, a, a, a, a, d, o, b, o, c, // row 13
            c, c, o, o, d, d, d, d, d, d, o, o, b, o, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "paladin_rest", name: "Paladin — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Paladin", groupOrder: 1)
    }()

    static let paladinAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#edab50"
        let a = "#ffd541"
        let d = "#edab50"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#ffffff"
        let g = "#edab50"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, w, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, w, w, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, w, w, o, h, h, h, h, o, c, c, c, c, c, // row 3
            c, c, c, g, g, o, d, d, d, d, o, c, c, c, c, c, // row 4
            c, c, c, c, c, o, s, e, k, e, o, c, c, c, c, c, // row 5
            c, c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, // row 6
            c, c, c, c, c, o, d, a, a, a, d, o, c, c, c, c, // row 7
            c, c, c, c, o, d, a, a, a, a, a, d, o, c, c, c, // row 8
            c, c, c, o, s, o, d, a, a, a, d, o, s, o, c, c, // row 9
            c, c, c, c, c, c, o, d, d, d, o, c, c, c, c, c, // row 10
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 11
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 12
            c, c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, // row 13
            c, c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "paladin_attack", name: "Paladin — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Paladin", groupOrder: 2)
    }()


    // MARK: - Ranger

    static let rangerIdle: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#33984b"
        let a = "#33984b"
        let d = "#1e6f50"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#5d2c28"
        let g = "#391f21"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, o, o, o, o, o, o, c, c, c, c, c, // row 1
            c, c, c, c, o, a, h, h, h, a, o, c, c, c, c, c, // row 2
            c, c, c, c, o, d, d, d, d, d, o, c, c, c, c, c, // row 3
            c, c, c, c, o, s, e, k, e, k, o, c, c, w, c, c, // row 4
            c, c, c, c, c, o, s, s, s, o, c, c, c, w, c, c, // row 5
            c, c, c, c, o, a, d, d, d, a, o, c, w, c, c, c, // row 6
            c, c, c, o, a, d, a, a, a, d, a, o, w, g, c, c, // row 7
            c, c, c, o, d, a, a, a, a, a, d, o, w, g, c, c, // row 8
            c, c, o, s, o, d, a, a, a, d, o, s, w, c, c, c, // row 9
            c, c, c, c, c, o, d, d, d, o, c, c, c, w, c, c, // row 10
            c, c, c, c, c, o, d, c, d, o, c, c, c, w, c, c, // row 11
            c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, c, // row 12
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 13
            c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "ranger_idle", name: "Ranger — Idle", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Ranger", groupOrder: 0)
    }()

    static let rangerRest: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#33984b"
        let a = "#33984b"
        let d = "#1e6f50"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#5d2c28"
        let g = "#391f21"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 3
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 4
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 5
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 6
            c, c, c, c, w, w, w, w, w, w, w, c, c, c, c, c, // row 7
            c, c, c, c, o, d, h, h, h, d, o, c, c, c, c, c, // row 8
            c, c, c, o, o, d, s, s, s, d, o, c, c, c, c, c, // row 9
            c, c, c, c, o, s, k, k, k, o, c, c, c, c, c, c, // row 10
            c, c, c, c, c, o, s, s, o, c, c, c, c, c, c, c, // row 11
            c, o, a, d, a, a, a, a, a, a, d, a, o, c, c, c, // row 12
            c, o, d, a, a, a, a, a, a, a, a, d, o, b, o, c, // row 13
            c, c, o, o, d, d, d, d, d, d, o, o, b, o, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "ranger_rest", name: "Ranger — Rest", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Ranger", groupOrder: 1)
    }()

    static let rangerAttack: PremadeSpriteData = {
        let c = "clear"
        let o = "#0e071b"
        let h = "#33984b"
        let a = "#33984b"
        let d = "#1e6f50"
        let s = "#bf6f4a"
        let e = "#ffffff"
        let k = "#131313"
        let b = "#391f21"
        let w = "#5d2c28"
        let g = "#391f21"

        let grid: [String] = [
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 0
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 1
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, // row 2
            c, c, c, c, c, o, h, h, h, h, o, c, c, c, c, c, // row 3
            c, c, w, c, c, o, d, d, d, d, o, c, c, c, c, c, // row 4
            c, c, w, c, c, o, s, e, k, e, o, c, c, c, c, c, // row 5
            c, g, w, g, g, c, o, s, s, o, c, c, c, c, c, c, // row 6
            c, c, w, c, c, o, d, a, a, a, d, o, c, c, c, c, // row 7
            c, c, w, c, o, d, a, a, a, a, a, d, o, c, c, c, // row 8
            c, c, w, o, s, o, d, a, a, a, d, o, s, o, c, c, // row 9
            c, c, c, c, c, c, o, d, d, d, o, c, c, c, c, c, // row 10
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 11
            c, c, c, c, c, c, o, d, c, d, o, c, c, c, c, c, // row 12
            c, c, c, c, c, o, b, b, c, b, b, o, c, c, c, c, // row 13
            c, c, c, c, c, o, b, c, c, c, b, o, c, c, c, c, // row 14
            c, c, c, c, c, c, c, c, c, c, c, c, c, c, c, c // row 15
        ]

        return PremadeSpriteData(id: "ranger_attack", name: "Ranger — Attack", canvasSize: .smallSquare, palette: .endesga64, pixelGrid: grid, group: "Ranger", groupOrder: 2)
    }()


}

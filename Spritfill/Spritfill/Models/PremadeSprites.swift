//
//  PremadeSprites.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import Foundation

struct PremadeSpriteData: Identifiable {
    let id: String
    let name: String
    let canvasSize: CanvasSizes
    let palette: ColorPalettes?
    let pixelGrid: [String]
    let group: String?
    let groupOrder: Int
    let paletteColors: [String]?
    let personalLink: String?
    
    init(id: String, name: String, canvasSize: CanvasSizes, palette: ColorPalettes? = nil, pixelGrid: [String], group: String? = nil, groupOrder: Int = 0, paletteColors: [String]? = nil, personalLink: String? = nil) {
        self.id = id
        self.name = name
        self.canvasSize = canvasSize
        self.palette = palette
        self.pixelGrid = pixelGrid
        self.group = group
        self.groupOrder = groupOrder
        self.paletteColors = paletteColors
        self.personalLink = personalLink
    }
    
    var resolvedPaletteColors: [String] {
        if let custom = paletteColors, !custom.isEmpty {
            return custom
        }
        if let palette = palette {
            return palette.colors.compactMap { $0.toHex() }
        }
        return []
    }
}

struct PremadeSprites {
    
    static let all: [PremadeSpriteData] = [
        // 32x32 Characters
        knightIdle32, knightAttack32, knightRun32,
        archerIdle32, archerAttack32, archerRun32,
        spearmanIdle32, spearmanAttack32, spearmanRun32,
        // Ducks
        duck1, duck2, duck3, duck4, duck5, duck6, duck7,
        // 32x32 Landscapes
        mountainRange, forest, sunset, castle, ocean, streetAtNight, studyRoom, citySkyrises,
        // 16x16 Items & Objects
        heart, pixelMan, sword, tree, mushroom, star, coin, skull,
        potion, shield, slime, gem, cat, dog, arrow, chest, key, crown,
        bomb, cactus, ghost, spaceship, avocado, flower,
        treasureMap, campfire, lantern,
        fire, rainbow, pokemonBall,
        // New 16x16 sprites
        moon, apple, lightning, snowflake, rocket,
        hourglass, alien, musicNote, penguin, sun,
        cupcake, frog, diamondRing, crab, candle, pawPrint,
        watermelon, bat, snowyVillage, desertPyramid, underwaterScene, spaceStation,
        autumnForest, wizardHat, iceCream, scroll,
        book, axe, bunny, questMark, pumpkin, wolf,
    ]
}

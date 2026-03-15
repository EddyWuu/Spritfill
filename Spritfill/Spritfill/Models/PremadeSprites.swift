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
    let palette: ColorPalettes
    let pixelGrid: [String]
    let group: String?
    let groupOrder: Int
    
    init(id: String, name: String, canvasSize: CanvasSizes, palette: ColorPalettes, pixelGrid: [String], group: String? = nil, groupOrder: Int = 0) {
        self.id = id
        self.name = name
        self.canvasSize = canvasSize
        self.palette = palette
        self.pixelGrid = pixelGrid
        self.group = group
        self.groupOrder = groupOrder
    }
}

struct PremadeSprites {
    
    static let all: [PremadeSpriteData] = [
        // 16x16 Characters
        knightIdle, knightRest, knightAttack,
        wizardIdle, wizardRest, wizardAttack,
        berserkerIdle, berserkerRest, berserkerAttack,
        samuraiIdle, samuraiRest, samuraiAttack,
        bowmanIdle, bowmanRest, bowmanAttack,
        vikingIdle, vikingRest, vikingAttack,
        guandaoIdle, guandaoRest, guandaoAttack,
        sorcererIdle, sorcererRest, sorcererAttack,
        clericIdle, clericRest, clericAttack,
        priestIdle, priestRest, priestAttack,
        warriorIdle, warriorRest, warriorAttack,
        spearmanIdle, spearmanRest, spearmanAttack,
        assassinIdle, assassinRest, assassinAttack,
        paladinIdle, paladinRest, paladinAttack,
        rangerIdle, rangerRest, rangerAttack,
        // 32x32 Landscapes
        mountainRange, forest, sunset, castle, ocean,
        // 16x16 Items & Objects
        heart, duck, pixelMan, sword, tree, mushroom, star, coin, skull,
        potion, shield, slime, gem, cat, dog, arrow, chest, key, crown,
        bomb, cactus, ghost, spaceship, avocado, flower, dragon,
        treasureMap, campfire, anchor, lantern,
    ]
}

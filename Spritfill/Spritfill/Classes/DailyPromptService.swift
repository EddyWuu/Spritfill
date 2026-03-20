//
//  DailyPromptService.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-20.
//

import Foundation

// Generates a deterministic daily drawing prompt from a curated list.
// All users see the same prompt on the same day — no network calls needed.
struct DailyPromptService {
    
    // Curated pixel-art-friendly drawing prompts.
    private static let prompts: [String] = [
        // Animals & creatures
        "A tiny dragon sleeping on a pile of gold",
        "A cat sitting in a cardboard box",
        "A frog wearing a tiny crown",
        "An owl perched on a crescent moon",
        "A goldfish in a round fishbowl",
        "A bunny holding a carrot",
        "A penguin wearing a scarf",
        "A snail with a house on its back",
        "A bee hovering over a flower",
        "A fox curled up by a campfire",
        "A baby turtle hatching from an egg",
        "A sloth hanging from a tree branch",
        "A jellyfish glowing in the deep sea",
        "A tiny bird on a wire",
        "A hedgehog carrying an apple",
        
        // Food & drink
        "A slice of pizza with melted cheese",
        "A steaming cup of coffee",
        "A stack of pancakes with syrup",
        "A cherry on top of a cupcake",
        "An ice cream cone with three scoops",
        "A bowl of ramen with chopsticks",
        "A juicy watermelon slice",
        "A donut with sprinkles",
        "A bento box with tiny compartments",
        "A bubble tea with tapioca pearls",
        
        // Nature & landscapes
        "A tiny island with a single palm tree",
        "A mushroom house in a forest",
        "A cactus in a desert at sunset",
        "A lighthouse on a rocky cliff",
        "A cherry blossom tree in spring",
        "A mountain with a flag on top",
        "A rainbow after a storm",
        "A tiny waterfall into a pond",
        "A field of sunflowers",
        "A cozy cabin in the snow",
        
        // Objects & items
        "A treasure chest overflowing with gems",
        "A magic potion bottle",
        "A pixel-art sword with a glowing blade",
        "A retro game controller",
        "A crystal ball on a stand",
        "A lantern glowing in the dark",
        "A pair of headphones",
        "A vintage camera",
        "A rocket ship blasting off",
        "A hot air balloon over mountains",
        
        // Characters & scenes
        "A knight standing guard",
        "A wizard casting a spell",
        "A robot waving hello",
        "A pirate with a parrot on their shoulder",
        "An astronaut floating in space",
        "A tiny chef cooking in a kitchen",
        "A ninja hiding behind a wall",
        "A ghost peeking around a corner",
        "A mermaid sitting on a rock",
        "A vampire under a full moon",
        
        // Abstract & creative
        "Your mood today as a color palette",
        "A portal to another dimension",
        "A heart made of smaller hearts",
        "The four seasons in one scene",
        "A yin-yang symbol with a twist",
        "An impossible staircase",
        "A pixel-art QR code that looks cool",
        "A tiny planet with its own ecosystem",
        "A clock melting like in a Dalí painting",
        "Symmetrical geometric pattern",
        
        // Seasonal / fun
        "A jack-o-lantern with a spooky face",
        "A snowman with a top hat",
        "A wrapped present with a bow",
        "A firework exploding in the night sky",
        "An Easter egg with a fancy pattern",
        "A four-leaf clover",
        "A beach scene with an umbrella",
        "A cozy fireplace with stockings",
        "A paper airplane in flight",
        "A message in a bottle on the shore",
        
        // Pixel-art specific
        "A sprite walk-cycle frame",
        "A tiny dungeon room with a door",
        "A floating island with waterfalls",
        "A health bar and UI elements",
        "A pixel-art self portrait",
        "A tile that could be a game floor",
        "An item shop with potions on shelves",
        "A boss monster with glowing eyes",
        "A treasure map with an X",
        "A pixel-art sunset gradient",
    ]
    
    // Returns today's prompt, deterministically chosen by the current date.
    static func todaysPrompt() -> String {
        let daysSinceEpoch = Calendar.current.ordinality(of: .day, in: .era, for: Date()) ?? 0
        let index = daysSinceEpoch % prompts.count
        return prompts[index]
    }
    
    // Returns the date string used for UserDefaults dismissal tracking.
    static func todaysKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "dailyPromptDismissed_\(formatter.string(from: Date()))"
    }
}

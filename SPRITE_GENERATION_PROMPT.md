# Sprite Generation Prompt for External LLM

Copy everything below the line and paste it into your Claude chat. Replace `[YOUR REQUEST HERE]` with what you want.

---

## PROMPT (copy from here) ↓

I need you to generate pixel art sprite data for a Swift iOS app called Spritfill. Output must be a valid Swift `static let` property inside an `extension PremadeSprites` block.

**My request:** [YOUR REQUEST HERE — e.g., "a lake louise landscape at 128x128", "a samurai character trio (idle/rest/attack) at 16x16", "a cute fox at 32x32"]

### Exact output format

```swift
extension PremadeSprites {

    static let mySpriteName: PremadeSpriteData = {
        // Define shorthand color variables at the top
        let c = "clear"  // transparent pixel — USE THIS for empty/background pixels
        let r = "#ea323c" // example: red
        // ... more color shorthands as needed

        let grid: [String] = [
            // row 0
            c, c, c, r, r, c, c, c, c, c, c, c, c, c, c, c,
            // row 1
            c, c, r, r, r, r, c, c, c, c, c, c, c, c, c, c,
            // ... continue for ALL rows
        ]

        return PremadeSpriteData(
            id: "my_sprite_name",
            name: "My Sprite Name",
            canvasSize: .smallSquare,    // see canvas sizes below
            palette: .endesga64,         // see palettes below
            pixelGrid: grid,
            group: "My Group",           // optional, nil for ungrouped
            groupOrder: 0                // order within group (0, 1, 2 for trio)
        )
    }()
}
```

### CRITICAL RULES — follow these exactly:

1. **Grid size must match canvas size exactly.** A 16×16 canvas = 256 elements. A 32×32 = 1024. A 64×64 = 4096. A 128×128 = 16384. Count them.

2. **Each row must have exactly `width` elements.** A 16-wide canvas has 16 comma-separated values per row. A 32-wide has 32. A 128-wide has 128. NO EXCEPTIONS.

3. **All colors must be lowercase hex strings** like `"#ea323c"`. Not uppercase. Not `0xEA323C`. Not `Color(...)`. Just the raw hex string.

4. **Use `"clear"` (the string) for transparent/empty pixels.** Not `""`, not `nil`, not `"transparent"`.

5. **Only use colors from the selected palette** (see palette hex values below). Do NOT invent colors.

6. **Use shorthand variables** for readability — define `let c = "clear"`, `let r = "#ea323c"` etc. at the top of the closure.

7. **Comment every row** — `// row 0`, `// row 1`, etc.

8. **For character trios (idle/rest/attack):**
   - `idle` — standing upright, weapon held at side, ready position
   - `rest` — lying down horizontally, sleeping (ZZZ indicators)
   - `attack` — dynamic action pose, weapon swinging/thrusting, body lunging
   - Set `group: "Character Name"` and `groupOrder: 0/1/2` for idle/rest/attack
   - Name them like `"Knight Idle"`, `"Knight Rest"`, `"Knight Attack"`
   - ID them like `"knight_idle"`, `"knight_rest"`, `"knight_attack"`

9. **Make it look good.** Use outlines, shading (highlight + base + shadow colors), and anti-aliasing where appropriate. Avoid flat blobs of single color.

### Available canvas sizes

| Swift enum case     | Dimensions | Total pixels |
|---------------------|-----------|-------------|
| `.smallSquare`      | 16 × 16   | 256         |
| `.mediumSquare`     | 32 × 32   | 1024        |
| `.largeSquare`      | 64 × 64   | 4096        |
| `.extraLargeSquare` | 128 × 128 | 16384       |
| `.wide`             | 64 × 32   | 2048        |
| `.tall`             | 32 × 64   | 2048        |
| `.landscape`        | 80 × 60   | 4800        |
| `.portrait`         | 60 × 80   | 4800        |

### Available palettes (use hex values from one of these)

**Endesga 64** (`.endesga64`) — 64 colors, best for detailed work:
```
#ff0040, #131313, #1b1b1b, #272727, #3d3d3d, #5d5d5d, #858585, #b4b4b4,
#ffffff, #c7cfdd, #92a1b9, #657392, #424c6e, #2a2f4e, #1a1932, #0e071b,
#1c121c, #391f21, #5d2c28, #8a4836, #bf6f4a, #e69c69, #f6ca9f, #f9e6cf,
#edab50, #e07438, #c64524, #8e251d, #ff5000, #ed7614, #ffa214, #ffc825,
#ffeb57, #d3fc7e, #99e65f, #5ac54f, #33984b, #1e6f50, #134c4c, #0c2e44,
#00396d, #0069aa, #0098dc, #00cdf9, #0cf1ff, #94fdff, #fdd2ed, #f389f5,
#db3ffd, #7a09fa, #3003d9, #0c0293, #03193f, #3b1443, #622461, #93388f,
#ca52c9, #c85086, #f68187, #f5555d, #ea323c, #c42430, #891e2b, #571c27
```

**Endesga 32** (`.endesga32`) — 32 colors:
```
#be4a2f, #d77643, #ead4aa, #e4a672, #b86f50, #733e39, #3e2731, #a22633,
#e43b44, #f77622, #feae34, #fee761, #63c74d, #3e8948, #265c42, #193c3e,
#124e89, #0099db, #2ce8f5, #ffffff, #c0cbdc, #8b9bb4, #5a6988, #3a4466,
#262b44, #181425, #ff0044, #68386c, #b55088, #f6757a, #e8b796, #c28569
```

**Zughy 32** (`.zughy32`) — 32 colors:
```
#472d3c, #5e3643, #7a444a, #a05b53, #bf7958, #eea160, #f4cca1, #b6d53c,
#71aa34, #397b44, #3c5956, #302c2e, #5a5353, #7d7071, #a0938e, #cfc6b8,
#dff6f5, #8aebf1, #28ccdf, #3978a8, #394778, #39314b, #564064, #8e478c,
#cd6093, #ffaeb6, #f4b41b, #f47e1b, #e6482e, #a93b3b, #827094, #4f546b
```

**Generic 16** (`.generic16`) — 16 colors:
```
#000000, #9d9d9d, #ffffff, #be2633, #e06f8b, #493c2b, #a46422, #eb8931,
#f7e26b, #2f484e, #44891a, #a3ce27, #1b2632, #005784, #31a2f2, #b2dcef
```

**Pico-8** (`.pico8`) — 16 colors:
```
#000000, #1d2b53, #7e2553, #008751, #ab5236, #5f574f, #c2c3c7, #fff1e8,
#ff004d, #ffa300, #ffec27, #00e436, #29adff, #83769c, #ff77a8, #ffccaa
```

### Full example — 16×16 Heart:

```swift
extension PremadeSprites {

    static let heart: PremadeSpriteData = {
        let c = "clear"
        let d = "#891e2b"
        let r = "#ea323c"
        let l = "#f68187"
        let w = "#ffffff"

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
}
```

Now generate the sprite I requested. Output ONLY the Swift code — no explanation before or after. Make sure the grid element count matches the canvas dimensions EXACTLY.

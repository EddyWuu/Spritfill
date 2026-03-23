//
//  BitmapExporter.swift
//  Spritfill
//
//  Renders pixel grids directly to UIImage via CGContext,
//  bypassing ImageRenderer / IOSurface to avoid oversized-surface crashes on large canvases.
//

import SwiftUI

enum BitmapExporter {

    // Maximum pixel dimension for a single side of the exported image.
    // Keeps memory usage under ~64 MB RGBA and avoids IOSurface limits.
    static let maxPixelSide = 4096

    // Minimum pixel dimension (longest side) for Photos exports.
    // Images smaller than this appear blurry in the iOS Photos app.
    static let minPhotosSize = 512

    // MARK: - Public API (hex strings)

    // Renders a flat hex-string pixel grid into a `UIImage`.
    // `tileSize` controls how many output pixels represent one grid cell.
    // The image is automatically down-scaled so that neither side exceeds `maxPixelSide`.
    static func renderImage(hexes: [String],
                            gridWidth: Int,
                            gridHeight: Int,
                            tileSize: Int) -> UIImage? {
        guard gridWidth > 0, gridHeight > 0, tileSize > 0 else { return nil }

        // Compute effective tile size so that the final image stays within limits.
        let effectiveTile = cappedTileSize(gridWidth: gridWidth,
                                           gridHeight: gridHeight,
                                           requestedTile: tileSize)

        let w = gridWidth * effectiveTile
        let h = gridHeight * effectiveTile
        guard w > 0, h > 0 else { return nil }

        var buffer = [UInt8](repeating: 0, count: w * h * 4)

        for row in 0..<gridHeight {
            for col in 0..<gridWidth {
                let index = row * gridWidth + col
                let hex = index < hexes.count ? hexes[index] : "clear"
                guard hex != "clear" else { continue }

                let rgb = fastParseHex(hex)

                for dy in 0..<effectiveTile {
                    let pixelRow = row * effectiveTile + dy
                    for dx in 0..<effectiveTile {
                        let pixelCol = col * effectiveTile + dx
                        let bi = (pixelRow * w + pixelCol) * 4
                        buffer[bi]     = rgb.r
                        buffer[bi + 1] = rgb.g
                        buffer[bi + 2] = rgb.b
                        buffer[bi + 3] = 255
                    }
                }
            }
        }

        return imageFromBuffer(&buffer, width: w, height: h)
    }

    // MARK: - Public API (SwiftUI Color array — used by RecreateCanvasViewModel)

    // Renders a flat `Color` pixel grid into a `UIImage`.
    static func renderImage(colors: [SwiftUI.Color],
                            gridWidth: Int,
                            gridHeight: Int,
                            tileSize: Int) -> UIImage? {
        // Convert Color array to hex strings and reuse the hex path.
        let hexes: [String] = colors.map { color in
            if color.isClear { return "clear" }
            return color.toHex() ?? "clear"
        }
        return renderImage(hexes: hexes,
                           gridWidth: gridWidth,
                           gridHeight: gridHeight,
                           tileSize: tileSize)
    }

    // MARK: - Photos upscale helpers

    // Returns `true` when the exported image's longest side is below `minPhotosSize`.
    static func needsUpscaleForPhotos(gridWidth: Int, gridHeight: Int, tileSize: Int) -> Bool {
        let effectiveTile = cappedTileSize(gridWidth: gridWidth,
                                           gridHeight: gridHeight,
                                           requestedTile: tileSize)
        let longest = max(gridWidth * effectiveTile, gridHeight * effectiveTile)
        return longest < minPhotosSize
    }

    // Returns the export resolution string (e.g. "128×128") for display purposes.
    static func exportResolutionLabel(gridWidth: Int, gridHeight: Int, tileSize: Int) -> String {
        let effectiveTile = cappedTileSize(gridWidth: gridWidth,
                                           gridHeight: gridHeight,
                                           requestedTile: tileSize)
        let w = gridWidth * effectiveTile
        let h = gridHeight * effectiveTile
        return "\(w)×\(h)"
    }

    // Nearest-neighbor upscale so the longest side reaches at least `minPhotosSize`.
    // Pixel-art stays sharp — no smoothing / antialiasing.
    static func upscaleForPhotos(_ image: UIImage) -> UIImage {
        let longest = max(image.size.width, image.size.height)
        guard longest < CGFloat(minPhotosSize), longest > 0 else { return image }

        let scale = ceil(CGFloat(minPhotosSize) / longest)   // integer multiplier → crisp pixels
        let newW = Int(image.size.width * scale)
        let newH = Int(image.size.height * scale)

        guard let cgImage = image.cgImage else { return image }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(
            data: nil,
            width: newW,
            height: newH,
            bitsPerComponent: 8,
            bytesPerRow: newW * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return image }

        ctx.interpolationQuality = .none   // nearest-neighbor
        ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: newW, height: newH))

        guard let scaled = ctx.makeImage() else { return image }
        return UIImage(cgImage: scaled)
    }

    // MARK: - Helpers

    // Reduces the tile size so that neither image dimension exceeds `maxPixelSide`.
    private static func cappedTileSize(gridWidth: Int,
                                       gridHeight: Int,
                                       requestedTile: Int) -> Int {
        let maxGrid = max(gridWidth, gridHeight)
        guard maxGrid > 0 else { return requestedTile }
        let maxAllowedTile = maxPixelSide / maxGrid
        return min(requestedTile, max(maxAllowedTile, 1))
    }

    private static func imageFromBuffer(_ buffer: inout [UInt8], width: Int, height: Int) -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(
            data: &buffer,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ), let cgImage = ctx.makeImage() else { return nil }

        return UIImage(cgImage: cgImage)
    }

    @inline(__always)
    private static func fastParseHex(_ hex: String) -> (r: UInt8, g: UInt8, b: UInt8) {
        let start = hex.hasPrefix("#") ? hex.utf8.index(after: hex.utf8.startIndex) : hex.utf8.startIndex
        let bytes = hex.utf8[start...]
        guard bytes.count >= 6 else { return (0, 0, 0) }
        var val: UInt32 = 0
        for byte in bytes.prefix(6) {
            val <<= 4
            switch byte {
            case 0x30...0x39: val |= UInt32(byte - 0x30)
            case 0x41...0x46: val |= UInt32(byte - 0x41 + 10)
            case 0x61...0x66: val |= UInt32(byte - 0x61 + 10)
            default: return (0, 0, 0)
            }
        }
        return (r: UInt8((val >> 16) & 0xFF), g: UInt8((val >> 8) & 0xFF), b: UInt8(val & 0xFF))
    }
}

//
//  ProjectCanvasExportView.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-27.
//

import SwiftUI

struct ProjectCanvasExportView: View {
    let viewModel: CanvasViewModel
    var overrideTileSize: CGFloat? = nil

    var body: some View {
        let tileSize = Int(overrideTileSize ?? CGFloat(viewModel.projectSettings.selectedTileSize))
        let gridWidth = viewModel.projectSettings.selectedCanvasSize.dimensions.width
        let gridHeight = viewModel.projectSettings.selectedCanvasSize.dimensions.height
        let compositeHexes = viewModel.compositePixelHexes()
        
        let image = renderExportBitmap(
            hexes: compositeHexes,
            gridWidth: gridWidth,
            gridHeight: gridHeight,
            tileSize: tileSize
        )
        
        if let image {
            Image(uiImage: image)
                .interpolation(.none)
                .resizable()
                .frame(width: CGFloat(gridWidth * tileSize), height: CGFloat(gridHeight * tileSize))
        }
    }
    
    // Renders the export image as a bitmap — much faster than 65K SwiftUI Path fills.
    private func renderExportBitmap(hexes: [String], gridWidth: Int, gridHeight: Int, tileSize: Int) -> UIImage? {
        let w = gridWidth * tileSize
        let h = gridHeight * tileSize
        guard w > 0, h > 0 else { return nil }
        
        // RGBA buffer
        var buffer = [UInt8](repeating: 0, count: w * h * 4)
        
        for row in 0..<gridHeight {
            for col in 0..<gridWidth {
                let index = row * gridWidth + col
                let hex = index < hexes.count ? hexes[index] : "clear"
                guard hex != "clear" else { continue }
                
                let rgb = fastParseHex(hex)
                
                // Fill the tileSize x tileSize block
                for dy in 0..<tileSize {
                    let pixelRow = row * tileSize + dy
                    for dx in 0..<tileSize {
                        let pixelCol = col * tileSize + dx
                        let bi = (pixelRow * w + pixelCol) * 4
                        buffer[bi]     = rgb.r
                        buffer[bi + 1] = rgb.g
                        buffer[bi + 2] = rgb.b
                        buffer[bi + 3] = 255
                    }
                }
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(
            data: &buffer, width: w, height: h,
            bitsPerComponent: 8, bytesPerRow: w * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ), let cgImage = ctx.makeImage() else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
    @inline(__always)
    private func fastParseHex(_ hex: String) -> (r: UInt8, g: UInt8, b: UInt8) {
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

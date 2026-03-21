//
//  LayerManagerViewModel.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-21.
//

import SwiftUI

/// Manages layer state, CRUD operations, compositing, and thumbnail rendering.
/// Extracted from CanvasViewModel to keep responsibilities focused.
class LayerManagerViewModel: ObservableObject {
    
    // MARK: - Layer (nested class)
    
    class Layer: Identifiable, ObservableObject {
        let id: UUID
        @Published var name: String
        @Published var pixels: [Color]
        var pixelHexes: [String]
        @Published var isVisible: Bool
        @Published var opacity: Double
        
        // Per-layer undo / redo
        var undoHistory: [[String]] = []
        var redoHistory: [[String]] = []
        
        init(id: UUID = UUID(), name: String, pixels: [Color], pixelHexes: [String], isVisible: Bool = true, opacity: Double = 1.0) {
            self.id = id
            self.name = name
            self.pixels = pixels
            self.pixelHexes = pixelHexes
            self.isVisible = isVisible
            self.opacity = opacity
        }
        
        // Create from a LayerData (persisted model)
        convenience init(from data: LayerData) {
            let colors = data.pixelGrid.map { hex in
                hex == "clear" ? Color.clear : Color(hex: hex)
            }
            self.init(id: data.id, name: data.name, pixels: colors, pixelHexes: data.pixelGrid,
                      isVisible: data.isVisible, opacity: data.opacity)
        }
        
        func toLayerData() -> LayerData {
            LayerData(id: id, name: name, pixelGrid: pixelHexes, isVisible: isVisible, opacity: opacity)
        }
    }
    
    // MARK: - Constants
    
    static let maxLayers = 8
    
    // MARK: - Published State
    
    @Published var layers: [Layer] = []
    @Published var activeLayerIndex: Int = 0
    
    var activeLayer: Layer {
        layers[activeLayerIndex]
    }
    
    // Proxy properties — reads/writes the active layer so existing CanvasViewModel code works.
    var pixels: [Color] {
        get { activeLayer.pixels }
        set { activeLayer.pixels = newValue }
    }
    
    var pixelHexes: [String] {
        get { activeLayer.pixelHexes }
        set { activeLayer.pixelHexes = newValue }
    }
    
    // MARK: - Compositing Cache
    
    private var cachedComposite: [String] = []
    private var cachedCompositeGeneration: UInt = UInt.max
    
    // MARK: - Init
    
    /// Initialize with a set of layers (from saved project or new project)
    init(layers: [Layer], activeLayerIndex: Int = 0) {
        self.layers = layers
        self.activeLayerIndex = activeLayerIndex
    }
    
    // MARK: - Layer CRUD
    
    func switchToLayer(at index: Int) {
        guard index >= 0, index < layers.count else { return }
        activeLayerIndex = index
    }
    
    func addLayer(totalPixels: Int) -> Bool {
        guard layers.count < Self.maxLayers else { return false }
        let newLayer = Layer(
            name: "Layer \(layers.count + 1)",
            pixels: Array(repeating: .clear, count: totalPixels),
            pixelHexes: Array(repeating: "clear", count: totalPixels)
        )
        let insertIndex = activeLayerIndex + 1
        layers.insert(newLayer, at: insertIndex)
        activeLayerIndex = insertIndex
        return true
    }
    
    func deleteLayer(at index: Int) -> Bool {
        guard layers.count > 1, index >= 0, index < layers.count else { return false }
        layers.remove(at: index)
        if activeLayerIndex >= layers.count {
            activeLayerIndex = layers.count - 1
        } else if activeLayerIndex > index {
            activeLayerIndex -= 1
        }
        return true
    }
    
    func duplicateLayer(at index: Int) -> Bool {
        guard layers.count < Self.maxLayers, index >= 0, index < layers.count else { return false }
        let source = layers[index]
        let copy = Layer(
            name: "\(source.name) copy",
            pixels: source.pixels,
            pixelHexes: source.pixelHexes,
            isVisible: source.isVisible,
            opacity: source.opacity
        )
        layers.insert(copy, at: index + 1)
        activeLayerIndex = index + 1
        return true
    }
    
    func moveLayer(from source: Int, to destination: Int) {
        guard source != destination,
              source >= 0, source < layers.count,
              destination >= 0, destination < layers.count else { return }
        let layer = layers.remove(at: source)
        layers.insert(layer, at: destination)
        // Keep active layer tracking the same layer object
        if activeLayerIndex == source {
            activeLayerIndex = destination
        } else if source < activeLayerIndex && destination >= activeLayerIndex {
            activeLayerIndex -= 1
        } else if source > activeLayerIndex && destination <= activeLayerIndex {
            activeLayerIndex += 1
        }
    }
    
    func toggleLayerVisibility(at index: Int) {
        guard index >= 0, index < layers.count else { return }
        layers[index].isVisible.toggle()
    }
    
    func setLayerOpacity(at index: Int, _ opacity: Double) {
        guard index >= 0, index < layers.count else { return }
        layers[index].opacity = opacity.clamped(to: 0...1)
    }
    
    func renameLayer(at index: Int, to name: String) {
        guard index >= 0, index < layers.count else { return }
        layers[index].name = name
    }
    
    func mergeDown(at index: Int) -> Bool {
        guard index > 0, index < layers.count else { return false }
        let upper = layers[index]
        let lower = layers[index - 1]
        
        for i in 0..<lower.pixelHexes.count {
            let hex = upper.pixelHexes[i]
            if hex != "clear" {
                if upper.opacity >= 1.0 {
                    lower.pixels[i] = upper.pixels[i]
                    lower.pixelHexes[i] = hex
                } else if upper.opacity > 0 {
                    let blended = blendHex(src: hex, dst: lower.pixelHexes[i], srcAlpha: upper.opacity)
                    lower.pixelHexes[i] = blended
                    lower.pixels[i] = Color(hex: blended)
                }
            }
        }
        
        layers.remove(at: index)
        if activeLayerIndex >= index {
            activeLayerIndex = max(0, activeLayerIndex - 1)
        }
        return true
    }
    
    func clearLayer(at index: Int) {
        guard index >= 0, index < layers.count else { return }
        let count = layers[index].pixels.count
        layers[index].pixels = Array(repeating: .clear, count: count)
        layers[index].pixelHexes = Array(repeating: "clear", count: count)
    }
    
    // MARK: - Compositing
    
    func compositePixelHexes(generation: UInt) -> [String] {
        if cachedCompositeGeneration == generation { return cachedComposite }
        
        guard !layers.isEmpty else { return [] }
        
        // Fast path: single layer with full opacity
        if layers.count == 1, layers[0].isVisible, layers[0].opacity >= 1.0 {
            cachedComposite = layers[0].pixelHexes
            cachedCompositeGeneration = generation
            return cachedComposite
        }
        
        let count = layers[0].pixelHexes.count
        var result = Array(repeating: "clear", count: count)
        
        let visibleLayers = layers.filter { $0.isVisible }
        guard !visibleLayers.isEmpty else {
            cachedComposite = result
            cachedCompositeGeneration = generation
            return result
        }
        
        for layer in visibleLayers {
            let opacity = layer.opacity
            let hexes = layer.pixelHexes
            if opacity >= 1.0 {
                for i in 0..<count {
                    let hex = hexes[i]
                    if hex != "clear" {
                        result[i] = hex
                    }
                }
            } else if opacity > 0 {
                for i in 0..<count {
                    let hex = hexes[i]
                    if hex != "clear" {
                        result[i] = blendHex(src: hex, dst: result[i], srcAlpha: opacity)
                    }
                }
            }
        }
        cachedComposite = result
        cachedCompositeGeneration = generation
        return result
    }
    
    // MARK: - Hex Blending Utilities
    
    func blendHex(src: String, dst: String, srcAlpha: Double) -> String {
        guard let sRGB = fastParseHex(src) else { return dst }
        let a = srcAlpha
        if dst == "clear" {
            let r = UInt8((Double(sRGB.r) / 255.0 * a + 1.0 * (1.0 - a)) * 255.0)
            let g = UInt8((Double(sRGB.g) / 255.0 * a + 1.0 * (1.0 - a)) * 255.0)
            let b = UInt8((Double(sRGB.b) / 255.0 * a + 1.0 * (1.0 - a)) * 255.0)
            return String(format: "#%02X%02X%02X", r, g, b)
        }
        guard let dRGB = fastParseHex(dst) else { return src }
        let r = UInt8((Double(sRGB.r) / 255.0 * a + Double(dRGB.r) / 255.0 * (1.0 - a)) * 255.0)
        let g = UInt8((Double(sRGB.g) / 255.0 * a + Double(dRGB.g) / 255.0 * (1.0 - a)) * 255.0)
        let b = UInt8((Double(sRGB.b) / 255.0 * a + Double(dRGB.b) / 255.0 * (1.0 - a)) * 255.0)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    @inline(__always)
    func fastParseHex(_ hex: String) -> (r: UInt8, g: UInt8, b: UInt8)? {
        let start = hex.hasPrefix("#") ? hex.utf8.index(after: hex.utf8.startIndex) : hex.utf8.startIndex
        let hexChars = hex.utf8[start...]
        guard hexChars.count >= 6 else { return nil }
        
        var val: UInt32 = 0
        for byte in hexChars.prefix(6) {
            val <<= 4
            switch byte {
            case 0x30...0x39: val |= UInt32(byte - 0x30)
            case 0x41...0x46: val |= UInt32(byte - 0x41 + 10)
            case 0x61...0x66: val |= UInt32(byte - 0x61 + 10)
            default: return nil
            }
        }
        return (r: UInt8((val >> 16) & 0xFF), g: UInt8((val >> 8) & 0xFF), b: UInt8(val & 0xFF))
    }
    
    // MARK: - Thumbnail Rendering
    
    /// Renders a layer's pixel data + checkerboard into a tiny CGImage bitmap.
    /// Pure byte-level operations — no SwiftUI Path fills, no Color conversions.
    func renderLayerThumbnail(hexes: [String], gridWidth: Int, gridHeight: Int) -> UIImage? {
        let w = gridWidth, h = gridHeight
        guard w > 0, h > 0 else { return nil }
        
        let lightGray: UInt8 = 235
        let darkGray: UInt8 = 215
        
        var buffer = [UInt8](repeating: 255, count: w * h * 4)
        
        for i in 0..<min(hexes.count, w * h) {
            let bi = i * 4
            let hex = hexes[i]
            
            if hex != "clear" {
                var str = hex
                if str.hasPrefix("#") { str = String(str.dropFirst()) }
                if str.count >= 6 {
                    var val: UInt32 = 0
                    for byte in str.utf8.prefix(6) {
                        val <<= 4
                        switch byte {
                        case 0x30...0x39: val |= UInt32(byte - 0x30)
                        case 0x41...0x46: val |= UInt32(byte - 0x41 + 10)
                        case 0x61...0x66: val |= UInt32(byte - 0x61 + 10)
                        default: break
                        }
                    }
                    buffer[bi]     = UInt8((val >> 16) & 0xFF)
                    buffer[bi + 1] = UInt8((val >> 8) & 0xFF)
                    buffer[bi + 2] = UInt8(val & 0xFF)
                }
            } else {
                let row = i / w, col = i % w
                let gray = (row + col) % 2 == 0 ? lightGray : darkGray
                buffer[bi] = gray; buffer[bi + 1] = gray; buffer[bi + 2] = gray
            }
            buffer[bi + 3] = 255
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
}

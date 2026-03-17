//
//  CustomPaletteService.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-16.
//

import Foundation

struct CustomPaletteData: Codable, Identifiable {
    let id: String
    var name: String
    var hexColors: [String]
}

class CustomPaletteService {
    
    static let shared = CustomPaletteService()
    
    private let directory: URL = {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = docs.appendingPathComponent("CustomPalettes")
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }()
    
    func savePalette(_ palette: CustomPaletteData) {
        let url = directory.appendingPathComponent("\(palette.id).json")
        if let data = try? JSONEncoder().encode(palette) {
            try? data.write(to: url)
        }
    }
    
    func fetchAllPalettes() -> [CustomPaletteData] {
        guard let files = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil) else {
            return []
        }
        return files
            .filter { $0.pathExtension == "json" }
            .compactMap { url -> CustomPaletteData? in
                guard let data = try? Data(contentsOf: url) else { return nil }
                return try? JSONDecoder().decode(CustomPaletteData.self, from: data)
            }
            .sorted { $0.name < $1.name }
    }
    
    func deletePalette(id: String) {
        let url = directory.appendingPathComponent("\(id).json")
        try? FileManager.default.removeItem(at: url)
    }
    
    func fetchPalette(by id: String) -> CustomPaletteData? {
        let url = directory.appendingPathComponent("\(id).json")
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(CustomPaletteData.self, from: data)
    }
}

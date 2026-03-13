//
//  LocalStorageService.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-03-13.
//

import Foundation

class LocalStorageService {
    
    static let shared = LocalStorageService()
    
    private let fileManager = FileManager.default
    
    private var projectsDirectory: URL {
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = documentsURL.appendingPathComponent("SpritfillProjects", isDirectory: true)
        
        if !fileManager.fileExists(atPath: dir.path) {
            try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        
        return dir
    }
    
    private func fileURL(for id: UUID) -> URL {
        projectsDirectory.appendingPathComponent("\(id.uuidString).json")
    }
    
    // MARK: - Save
    
    func saveProject(_ project: ProjectData) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(project)
            try data.write(to: fileURL(for: project.id), options: .atomic)
        } catch {
            print("Error saving project: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fetch All
    
    func fetchAllProjects() -> [ProjectData] {
        do {
            let files = try fileManager.contentsOfDirectory(at: projectsDirectory,
                                                             includingPropertiesForKeys: nil)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return files.compactMap { url -> ProjectData? in
                guard url.pathExtension == "json" else { return nil }
                guard let data = try? Data(contentsOf: url) else { return nil }
                return try? decoder.decode(ProjectData.self, from: data)
            }
            .sorted { $0.lastEdited > $1.lastEdited }
        } catch {
            print("Error fetching projects: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Delete
    
    func deleteProject(_ project: ProjectData) {
        let url = fileURL(for: project.id)
        try? fileManager.removeItem(at: url)
    }
    
    // MARK: - Fetch Single
    
    func fetchProject(by id: UUID) -> ProjectData? {
        let url = fileURL(for: id)
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(ProjectData.self, from: data)
    }
}

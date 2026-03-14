//
//  RecreateStorageService.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-14.
//

import Foundation

class RecreateStorageService {
    
    static let shared = RecreateStorageService()
    
    private let fileManager = FileManager.default
    
    private var sessionsDirectory: URL {
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = docs.appendingPathComponent("RecreateSessions", isDirectory: true)
        if !fileManager.fileExists(atPath: dir.path) {
            try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }
    
    private func fileURL(for id: UUID) -> URL {
        sessionsDirectory.appendingPathComponent("\(id.uuidString).json")
    }
    
    // MARK: - Save
    
    func saveSession(_ session: RecreateSession) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(session)
            try data.write(to: fileURL(for: session.id), options: .atomic)
        } catch {
            print("Error saving recreate session: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fetch All
    
    func fetchAllSessions() -> [RecreateSession] {
        do {
            let files = try fileManager.contentsOfDirectory(at: sessionsDirectory,
                                                             includingPropertiesForKeys: nil)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return files.compactMap { url -> RecreateSession? in
                guard url.pathExtension == "json" else { return nil }
                guard let data = try? Data(contentsOf: url) else { return nil }
                return try? decoder.decode(RecreateSession.self, from: data)
            }
            .sorted { $0.lastEdited > $1.lastEdited }
        } catch {
            return []
        }
    }
    
    // MARK: - Delete
    
    func deleteSession(id: UUID) {
        let url = fileURL(for: id)
        try? fileManager.removeItem(at: url)
    }
    
    // MARK: - Fetch Single
    
    func fetchSession(by id: UUID) -> RecreateSession? {
        let url = fileURL(for: id)
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(RecreateSession.self, from: data)
    }
    
    // MARK: - Find existing session for a sprite
    
    func findSession(sourceType: RecreateSource, sourceID: String) -> RecreateSession? {
        return fetchAllSessions().first {
            $0.sourceType == sourceType && $0.sourceID == sourceID
        }
    }
}

//
//  FirebaseSubmissionService.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-18.
//

import Foundation
import UIKit
import FirebaseFirestore

class FirebaseSubmissionService {
    
    static let shared = FirebaseSubmissionService()
    
    private let db = Firestore.firestore()
    
    private static let dailyLimitKey = "dailySubmissionCount"
    private static let dailyLimitDateKey = "dailySubmissionDate"
    static let maxDailySubmissions = 10
    
    private init() {}
    
    // MARK: - Daily submission limit
    
    // Number of submissions made today.
    var todaySubmissionCount: Int {
        resetIfNewDay()
        return UserDefaults.standard.integer(forKey: Self.dailyLimitKey)
    }
    
    // Whether the user has reached the daily submission limit.
    var hasReachedDailyLimit: Bool {
        todaySubmissionCount >= Self.maxDailySubmissions
    }
    
    // Remaining submissions available today.
    var remainingSubmissions: Int {
        max(0, Self.maxDailySubmissions - todaySubmissionCount)
    }
    
    private func resetIfNewDay() {
        let storedDate = UserDefaults.standard.string(forKey: Self.dailyLimitDateKey) ?? ""
        let todayString = Self.todayDateString()
        if storedDate != todayString {
            UserDefaults.standard.set(0, forKey: Self.dailyLimitKey)
            UserDefaults.standard.set(todayString, forKey: Self.dailyLimitDateKey)
        }
    }
    
    private func incrementDailyCount() {
        resetIfNewDay()
        let current = UserDefaults.standard.integer(forKey: Self.dailyLimitKey)
        UserDefaults.standard.set(current + 1, forKey: Self.dailyLimitKey)
    }
    
    private static func todayDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    // Submits artwork for review
    // - Parameters:
    //   - submission: The submission metadata
    //   - image: The rendered PNG image of the artwork
    //   - completion: Returns success or error
    func submitArtwork(submission: ArtSubmission, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard !hasReachedDailyLimit else {
            completion(.failure(SubmissionError.dailyLimitReached))
            return
        }
        
        guard let pngData = image.pngData() else {
            completion(.failure(SubmissionError.imageConversionFailed))
            return
        }
        
        let imageBase64 = pngData.base64EncodedString()
        
        var data: [String: Any] = [
            "id": submission.id.uuidString,
            "artistName": submission.artistName,
            "projectName": submission.projectName,
            "canvasWidth": submission.canvasWidth,
            "canvasHeight": submission.canvasHeight,
            "pixelGrid": submission.pixelGrid,
            "imageBase64": imageBase64,
            "submittedAt": Timestamp(date: Date()),
            "status": "pending_review"
        ]
        
        if let personalLink = submission.personalLink {
            data["personalLink"] = personalLink
        }
        
        db.collection("submissions").document(submission.id.uuidString).setData(data) { [weak self] error in
            if let error = error {
                completion(.failure(error))
            } else {
                self?.incrementDailyCount()
                completion(.success(()))
            }
        }
    }
    
    enum SubmissionError: LocalizedError {
        case imageConversionFailed
        case dailyLimitReached
        
        var errorDescription: String? {
            switch self {
            case .imageConversionFailed:
                return "Failed to convert artwork to PNG."
            case .dailyLimitReached:
                return "You've reached the daily submission limit of \(FirebaseSubmissionService.maxDailySubmissions). Please try again tomorrow."
            }
        }
    }
}

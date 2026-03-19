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
    
    private init() {}
    
    /// Submits artwork for review
    /// - Parameters:
    ///   - submission: The submission metadata
    ///   - image: The rendered PNG image of the artwork
    ///   - completion: Returns success or error
    func submitArtwork(submission: ArtSubmission, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let pngData = image.pngData() else {
            completion(.failure(SubmissionError.imageConversionFailed))
            return
        }
        
        let imageBase64 = pngData.base64EncodedString()
        
        let data: [String: Any] = [
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
        
        db.collection("submissions").document(submission.id.uuidString).setData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    enum SubmissionError: LocalizedError {
        case imageConversionFailed
        
        var errorDescription: String? {
            switch self {
            case .imageConversionFailed:
                return "Failed to convert artwork to PNG."
            }
        }
    }
}

//
//  PhotoSaver.swift
//  Spritfill
//
//  Created by Edmond Wu on 2026-03-17.
//

import UIKit
import Photos

/// Saves a UIImage as PNG to the photo library, preserving transparency.
/// UIImageWriteToSavedPhotosAlbum converts to JPEG (no alpha), so we use PHPhotoLibrary instead.
enum PhotoSaver {
    
    static func saveAsPNG(_ image: UIImage, completion: (() -> Void)? = nil) {
        guard let pngData = image.pngData() else {
            completion?()
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async { completion?() }
                return
            }
            
            PHPhotoLibrary.shared().performChanges {
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .photo, data: pngData, options: nil)
            } completionHandler: { _, _ in
                DispatchQueue.main.async { completion?() }
            }
        }
    }
}

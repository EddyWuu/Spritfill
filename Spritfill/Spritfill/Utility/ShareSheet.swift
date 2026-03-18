//
//  ShareSheet.swift
//  Spritfill
//
//  Created by Edmond Wu on 2025-07-27.
//

import UIKit
import SwiftUI
import UniformTypeIdentifiers

/// Activity item provider that vends PNG data so shared images always stay PNG (not JPEG).
/// Avoids file-URL–based sharing which causes LaunchServices errors on dev-signed apps.
class PNGImageItemProvider: UIActivityItemProvider, @unchecked Sendable {
    
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        // Placeholder must be a UIImage so the share sheet shows the correct preview
        super.init(placeholderItem: image)
    }
    
    override var item: Any {
        // Return PNG data so recipients get a .png, not .jpeg
        return image.pngData() ?? image
    }
    
    override func activityViewController(
        _ activityViewController: UIActivityViewController,
        dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?
    ) -> String {
        return UTType.png.identifier
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        // Wrap UIImage items in PNGImageItemProvider to ensure PNG format
        let wrappedItems: [Any] = activityItems.map { item in
            if let image = item as? UIImage {
                return PNGImageItemProvider(image: image)
            }
            return item
        }
        
        return UIActivityViewController(
            activityItems: wrappedItems,
            applicationActivities: applicationActivities
        )
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

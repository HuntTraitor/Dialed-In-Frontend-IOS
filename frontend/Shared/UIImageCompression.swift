//
//  UIImageCompression.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/2/25.
//

import UIKit

extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    /// Compresses image to under a given size (in KB), returns JPEG data
    func compressTo(maxSizeInKB: Int) -> Data? {
        let resized = self.aspectFittedToHeight(200) // adjust if needed
        var compression: CGFloat = 0.2
        let maxSizeBytes = maxSizeInKB * 1024

        guard var compressedData = resized.jpegData(compressionQuality: compression) else {
            return nil
        }
        
        while compressedData.count > maxSizeBytes && compression > 0 {
            compression -= 0.1
            if let data = resized.jpegData(compressionQuality: compression) {
                compressedData = data
            } else {
                return nil
            }
        }

        return compressedData.count <= maxSizeBytes ? compressedData : nil
    }
}


//
//  UIImageCompression.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/2/25.
//

import UIKit

extension UIImage {
    /// Resize while keeping aspect ratio so that the longest side == maxDimension
    func aspectFitted(toMaxDimension maxDimension: CGFloat) -> UIImage {
        let width = size.width
        let height = size.height
        
        let maxCurrentDimension = max(width, height)
        guard maxCurrentDimension > maxDimension else { return self }
        
        let scale = maxDimension / maxCurrentDimension
        let newSize = CGSize(width: width * scale, height: height * scale)
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    /// Compresses image (after resizing) to under a given size (in KB), returns JPEG data
    /// - Parameters:
    ///   - maxSizeInKB: target max size in kilobytes
    ///   - maxDimension: longest side (in pixels/points) after resize
    func compressTo(maxSizeInKB: Int,
                    maxDimension: CGFloat = 1600) -> Data? {
        let resized = self.aspectFitted(toMaxDimension: maxDimension)
        
        let maxSizeBytes = maxSizeInKB * 1024
        
        var compression: CGFloat = 0.8
        let minCompression: CGFloat = 0.7  // don't go below this or it gets ugly
        
        guard var compressedData = resized.jpegData(compressionQuality: compression) else {
            return nil
        }
        
        if compressedData.count <= maxSizeBytes {
            return compressedData
        }
        
        while compressedData.count > maxSizeBytes && compression > minCompression {
            compression -= 0.05
            
            if let data = resized.jpegData(compressionQuality: compression) {
                compressedData = data
            } else {
                break
            }
        }
        
        return compressedData.count <= maxSizeBytes ? compressedData : nil
    }
}



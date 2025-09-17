////
////  UIImage.swift
////  SmartSpend
////
////  Created by Refik Jaija on 16.9.25.
////
//
//import Foundation
//import UIKit
//
//extension UIImage {
//    func resizedToSafeSize(maxDimension: CGFloat = 1024) -> UIImage {
//        let aspectRatio = size.width / size.height
//        var newSize: CGSize
//        if aspectRatio > 1 {
//            // Landscape
//            newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
//        } else {
//            // Portrait
//            newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
//        }
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        draw(in: CGRect(origin: .zero, size: newSize))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage ?? self
//    }
//}


import UIKit
import UniformTypeIdentifiers
import ImageIO

extension UIImage {
    func resizedToSafeSize(maxDimension: CGFloat = 1024) -> UIImage {
        let aspectRatio = size.width / size.height
        var newSize: CGSize
        if aspectRatio > 1 {
            newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }
        
        // Use device scale for sharpness (2x / 3x on Retina)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
    
    func jpegDataOptimized(quality: CGFloat = 0.8) -> Data? {
        guard let cgImage = self.cgImage else {
            return self.jpegData(compressionQuality: quality)
        }
        
        let data = NSMutableData()
        guard let dest = CGImageDestinationCreateWithData(data, UTType.jpeg.identifier as CFString, 1, nil) else {
            return self.jpegData(compressionQuality: quality)
        }
        
        let options: [CFString: Any] = [
            kCGImageDestinationLossyCompressionQuality: quality,
            kCGImagePropertyJFIFIsProgressive: true
        ]
        
        CGImageDestinationAddImage(dest, cgImage, options as CFDictionary)
        CGImageDestinationFinalize(dest)
        
        return data as Data
    }
}

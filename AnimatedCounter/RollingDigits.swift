//
//  RollingDigits.swift
//  AnimatedCounter
//
//  Created by Alexey on 4/06/2016.
//  Copyright © 2016 Alexey Zhilnikov. All rights reserved.
//

import UIKit

private let maximumImagesNumber =   21

class RollingDigits {
    
    static let sharedInstance = RollingDigits()
    
    // MARK: - Public methods
    
    // Return array of images to animate
    // Image name format: PNXX, where P - previous digit, N - new digit, XX - image number
    // For example, to animate changes from 3 to 4 array should contain images with names 3400...3420
    func imagesFrom(previousDigit: String, To newDigit: String) -> [UIImage] {
        
        var images = [UIImage]()
        
        for index in 0..<maximumImagesNumberFrom(previousDigit, To: newDigit) {
            let imageName = previousDigit + newDigit + String(format: "%.2d", index)
            // Add image
            images.append(UIImage(named: imageName)!)
        }
        return images
    }
    
    // Return last image used to animate changes from old digit to a new one
    func lastImageFrom(previousDigit: String, To newDigit: String) -> UIImage {
        // Maximum number of images
        let number = maximumImagesNumberFrom(previousDigit, To: newDigit)
        let imageName = previousDigit + newDigit + String(format: "%.2d", number - 1)
        return UIImage(named: imageName)!
    }
    
    // MARK: - Private methods
    
    // Return maximum number of images used to animate changes from old digit to a new one
    private func maximumImagesNumberFrom(previousDigit: String, To newDigit: String) -> Int {
        // Images 5 -> 6 have one more image
        return (previousDigit == "5" && newDigit == "6") ? maximumImagesNumber + 1
                                                         : maximumImagesNumber
    }
}

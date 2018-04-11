//
//  Filter+CoreImage.swift
//  mvPhotosApp
//
//  Created by Mikhail Kirillov on 11/04/2018.
//  Copyright © 2018 Mikhail Kirillov. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

@objc enum FilterType: Int32, CoreImageFilter {
    case mirror
    case colorInverse
    case rotate

    var filterName: String {
        switch self {
        case .mirror:
            return "Mirror image"
        case .colorInverse:
            return "Invert image colors"
        case .rotate:
            return "Rotate image"
        }
    }

    func applyToImage(_ image: UIImage) -> UIImage {
        switch self {
        case .mirror:
            return affineTransformImage(image, CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0))
        case .colorInverse:
            return invertColors(image)
        case .rotate:
            return affineTransformImage(image, CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0))
        }
    }

    private func invertColors(_ image: UIImage) -> UIImage {
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setDefaults()
        filter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        return UIImage.init(ciImage: filter!.outputImage!) 
    }

    private func affineTransformImage(_ image: UIImage, _ inputTransform: CGAffineTransform) -> UIImage {
        let filter = CIFilter(name: "CIAffineTransform")
        let inputTransformValue = NSValue(cgAffineTransform: inputTransform)
        filter?.setDefaults()
        filter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        filter?.setValue(inputTransformValue, forKey: kCIInputTransformKey)
        return UIImage.init(ciImage: filter!.outputImage!)
    }
}

extension Filter {

    

    var filterType: FilterType {
        get {
            return FilterType(rawValue: type)!
        }
        set {
            self.type = newValue.rawValue
        }
    }
}

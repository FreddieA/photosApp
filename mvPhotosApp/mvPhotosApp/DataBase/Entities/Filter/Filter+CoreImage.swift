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

enum FilterType: CoreImageFilter {
    case mirror
    case rotate
    case blackAndWhite
    
    private var filterName: String {
        switch self {
        case .mirror:
            return "CIAffineTransform"
        case .rotate:
            return "CIAffineTransform"
        case .blackAndWhite:
            return "CIColorMonochrome"
        }
    }
    
    private var filterAttributes: [String : Any] {
        switch self {
        case .mirror:
            return [kCIInputTransformKey : NSValue(cgAffineTransform: CGAffineTransform.init(scaleX: -1, y: 1))]
        case .rotate:
            return [kCIInputTransformKey : NSValue(cgAffineTransform: CGAffineTransform.init(rotationAngle: CGFloat.pi / 2))]
        case .blackAndWhite:
            return [kCIInputColorKey : CIColor.init(color: .white), kCIInputIntensityKey: NSNumber.init(value: 1)]
        }
    }
    
    func applyToImage(_ image: UIImage) -> UIImage? {
        if let ciimage = CIImage(image: image) {
            let context = CIContext()
            let resultCiImage = ciimage.applyingFilter(filterName, parameters: filterAttributes)
            if let cgImage = context.createCGImage(resultCiImage, from: resultCiImage.extent) {
                return UIImage.init(cgImage: cgImage)
            }
        }
        return nil
    }
}

//
//  FilterImageProcessor.swift
//  mvPhotosApp
//
//  Created by Mikhail Kirillov on 10/04/2018.
//  Copyright © 2018 Mikhail Kirillov. All rights reserved.
//

import CoreImage
import UIKit

protocol CoreImageFilter {

    var filterName: String { get }

    func applyToImage(_ image: CIImage) -> UIImage
}

extension NSObject: CoreImageFilter {
    var filterName: String {
        return "filter"
    }

    func applyToImage(_ image: CIImage) -> UIImage {
        return UIImage()
    }
}

class FilterImageProcessor {

    static func applyFilter(image: UIImage, filter: CoreImageFilter) -> UIImage {
        return UIImage()
    }

    static func applyFilter(image: UIImage, filter: CoreImageFilter, progress: (Int, UIImage) -> Void) {
        
    }
}

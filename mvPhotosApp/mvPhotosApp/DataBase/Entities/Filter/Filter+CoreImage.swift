//
//  Filter+CoreImage.swift
//  mvPhotosApp
//
//  Created by Mikhail Kirillov on 11/04/2018.
//  Copyright © 2018 Mikhail Kirillov. All rights reserved.
//

import Foundation
import CoreImage

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

    func applyToImage(_ image: CIImage) -> CIImage {
        return CIImage.empty()
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

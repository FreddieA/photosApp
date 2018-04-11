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
    
    func applyToImage(_ image: UIImage) -> UIImage
}

//
//  ImageFilterOperation.swift
//  mvPhotosApp
//
//  Created by Mikhail Kirillov on 10/04/2018.
//  Copyright © 2018 Mikhail Kirillov. All rights reserved.
//

import Foundation
import UIKit

class ImageFilterOperation: AsyncOperation {

    private var image: UIImage
    private var filter: CoreImageFilter
    private var timer: Timer?
    var progressCallback: ((ImageFilterOperation) -> Void)?

    private var fakeTimeout: Double = 0.0
    private var elapsedTime: Double = 0.0

    var resultingImageData: Data? {
        guard let ciImage: CIImage = CIImage(image: image) else {
            return nil
        }
        if let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) {
            let image = UIImage(cgImage: cgImage)
            return UIImagePNGRepresentation(image)
        }
        return nil
    }
    var progress: Double {
        return elapsedTime / fakeTimeout
    }
    var title: String {
        return "(operation\(fakeTimeout))"
    }

    init(filterToApply: CoreImageFilter, originalImage: UIImage) {
        image = originalImage
        filter = filterToApply
        fakeTimeout = Double(arc4random_uniform(26) + 5)
    }

    override var isConcurrent: Bool {
        return true
    }

    override func start() {
        super.start()

        self.state = .executing

        timer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }

    @objc private func updateTimer(timer: Timer) {
        elapsedTime += timer.timeInterval

        if elapsedTime >= fakeTimeout {
            timer.invalidate()
            self.state = .finished
        }
        progressCallback?(self)
    }
}

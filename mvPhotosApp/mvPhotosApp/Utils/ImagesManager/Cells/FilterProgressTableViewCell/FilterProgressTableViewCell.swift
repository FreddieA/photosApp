//
//  FilterProgressTableViewCell.swift
//  mvPhotosApp
//
//  Created by Mikhail Kirillov on 11/04/2018.
//  Copyright © 2018 Mikhail Kirillov. All rights reserved.
//

import UIKit
import CoreGraphics

class FilterProgressTableViewCell: UITableViewCell {

    @IBOutlet weak var progressView: UIView!
    
    private weak var operation: ImageFilterOperation?

    private func updateProgress(progress: Double) {

        let width = self.contentView.bounds.width - 8 * 2
        progressView.frame = CGRect.init(x: progressView.frame.minX,
                                         y: progressView.frame.minY,
                                         width: min(width, width * CGFloat(progress)),
                                         height: progressView.frame.height)
    }
    
    func setOperation(_ filterOperation: ImageFilterOperation) {
        operation = filterOperation
        operation?.progressCallback = { [weak self] operation in
            self?.updateProgress(progress: operation.progress)
        }
    }
    
    override func prepareForReuse() {
        operation?.progressCallback = nil
    }
}

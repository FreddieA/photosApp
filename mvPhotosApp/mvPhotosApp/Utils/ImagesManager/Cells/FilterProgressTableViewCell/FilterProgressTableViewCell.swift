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

    func updateProgress(progress: Double) {

        let width = self.contentView.bounds.width - 8 * 2
        progressView.frame = CGRect.init(x: progressView.frame.minX,
                                         y: progressView.frame.minY,
                                         width: min(width, width * CGFloat(progress)),
                                         height: progressView.frame.height)
    }
}

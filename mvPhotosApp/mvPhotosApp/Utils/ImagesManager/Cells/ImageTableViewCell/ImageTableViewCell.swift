//
//  ImageTableViewCell.swift
//  mvPhotosApp
//
//  Created by Mikhail Kirillov on 11/04/2018.
//  Copyright © 2018 Mikhail Kirillov. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filteredImageView: UIImageView!
    
    func setImageObject(object: Image) {
        DispatchQueue.main.async {
            if let data = object.imageData, let image = UIImage(data: data) {
                self.filteredImageView.image = image
            }
        }
    }
}

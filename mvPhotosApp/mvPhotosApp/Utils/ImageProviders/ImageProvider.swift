//
//  ImageProvider.swift
//  mvPhotosApp
//
//  Created by Mikhail Kirillov on 09/04/2018.
//  Copyright © 2018 Mikhail Kirillov. All rights reserved.
//

import UIKit

protocol ImageProvider: class {

    func title() -> String
    func hasPermission() -> Bool
    func sourceIsAvailiable() -> Bool

    func requestPermission(_ completion: @escaping (Bool) -> Void)
    func retrieveImage(_ completion: @escaping (UIImage?) -> Void)
}

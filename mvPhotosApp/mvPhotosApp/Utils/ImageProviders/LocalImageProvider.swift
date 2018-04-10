//
//  BaseSyncImageProvider.swift
//  mvPhotosApp
//
//  Created by Mikhail Kirillov on 10/04/2018.
//  Copyright © 2018 Mikhail Kirillov. All rights reserved.
//

import UIKit
import Photos

class LocalImageProvider: NSObject, ImageProvider {

    var pickerCompletion: ((UIImage?) -> Void)?
    weak var ownerController: UIViewController?

    init(_ controller: UIViewController) {
        ownerController = controller
    }

    func title() -> String {
        return "Get image from camera or library"
    }

    func hasPermission() -> Bool {
        return false
    }

    func sourceIsAvailiable() -> Bool {
        return false
    }

    func requestPermission(_ completion: @escaping (Bool) -> Void) {
        completion(false)
    }

    func retrieveImage(_ completion: @escaping (UIImage?) -> Void) {
        completion(nil)
    }
}

extension LocalImageProvider: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let completion = pickerCompletion {
            completion(image)
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if let completion = pickerCompletion {
            completion(nil)
        }
        picker.dismiss(animated: true)
    }
}

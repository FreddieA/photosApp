//
//  PhotosImageProvider.swift
//  mvPhotosApp
//
//  Created by Mikhail Kirillov on 09/04/2018.
//  Copyright © 2018 Mikhail Kirillov. All rights reserved.
//

import UIKit
import Photos

class GalleryImageProvider: LocalImageProvider {

    override func title() -> String {
        return "Gallery"
    }

    override func hasPermission() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }

    override func sourceIsAvailiable() -> Bool {
        return true
    }
    
    override func requestPermission(_ completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            completion(status == .authorized)
        }
    }
    
    override func retrieveImage(_ completion: @escaping (UIImage?) -> Void) {
        pickerCompletion = completion
        
        let picker = UIImagePickerController.init()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        ownerController?.present(picker, animated: true)
    }
}

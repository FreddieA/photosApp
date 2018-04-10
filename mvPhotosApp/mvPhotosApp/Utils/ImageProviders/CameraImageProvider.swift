//
//  CameraImageProvider.swift
//  mvPhotosApp
//
//  Created by Mikhail Kirillov on 09/04/2018.
//  Copyright © 2018 Mikhail Kirillov. All rights reserved.
//

import UIKit
import AVFoundation

class CameraImageProvider: LocalImageProvider {

    override func title() -> String {
        return "Camera"
    }

    override func hasPermission() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }

    override func sourceIsAvailiable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func requestPermission(_ completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: completion)
    }

    override func retrieveImage(_ completion: @escaping (UIImage?) -> Void) {
        pickerCompletion = completion

        let picker = UIImagePickerController.init()
        picker.sourceType = .camera
        picker.delegate = self
        ownerController?.present(picker, animated: true)
    }
}

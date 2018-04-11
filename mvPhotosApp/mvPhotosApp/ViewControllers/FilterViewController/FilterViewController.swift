//
//  FilterViewController.swift
//  mvPhotosApp
//
//  Created by Mikhail Kirillov on 09/04/2018.
//  Copyright © 2018 Mikhail Kirillov. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var imagesTableView: UITableView!

    private var imagesManager = ImagesManager()
    private var imageProviders: [ImageProvider] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        imageProviders = [GalleryImageProvider(self), CameraImageProvider(self)]
        imagesTableView.dataSource = imagesManager
        imagesTableView.delegate = self

        imagesManager.imagesTableView = imagesTableView
        imagesManager.refresh()
    }

    @IBAction func mirrorAction(_ sender: UIButton) {
        if let image = selectedImageView.image {
            imagesManager.addImage(image: image, filter: .mirror)
        }
    }
    
    @IBAction func selectImageAction(_ sender: UIButton) {

        let controller = UIAlertController.init(title: "Select image from:", message: nil, preferredStyle: .actionSheet)
        imageProviders.forEach { provider in
            guard provider.sourceIsAvailiable() else {
                return
            }

            controller.addAction(UIAlertAction.init(title: provider.title(),
                                                    style: .default,
                                                    handler: { [weak self] action in
                                                        self?.retrieveImageIfPermitted(provider)
            }))
        }
        controller.addAction(UIAlertAction.init(title: "Cancel", style: .destructive))
        self.present(controller, animated: true)
    }

    private func retrieveImageIfPermitted(_ provider: ImageProvider) {
        if !provider.hasPermission() {
            provider.requestPermission({ granted in
                if granted {
                    self.retrieveImage(provider)
                }
            })
        } else {
            retrieveImage(provider)
        }
    }

    private func retrieveImage(_ provider: ImageProvider) {
        provider.retrieveImage { image in
            self.handleImageSelection(image)
        }
    }

    private func handleImageSelection(_ image: UIImage?) {
        selectedImageView.image = image
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

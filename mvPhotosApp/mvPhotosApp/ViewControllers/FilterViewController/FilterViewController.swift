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
    @IBOutlet weak var noImagesLabel: UILabel!
    
    private var imagesManager = ImagesManager()
    private var imageProviders: [ImageProvider] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedImageView.image = #imageLiteral(resourceName: "placeholder")
        
        setUpImageManagement()
        setUpTable()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveAction))
    }
    
    @objc private func saveAction() {
        do {
            try DataBaseHelper.shared.mainContext.save()
        } catch {
            debugPrint(error)
        }
    }
    
    private func setUpImageManagement() {
        imageProviders = [GalleryImageProvider(self), CameraImageProvider(self)]
        imagesTableView.dataSource = imagesManager
        imagesTableView.delegate = self
        
        imagesManager.imagesTableView = imagesTableView
        imagesManager.noImagesLabel = noImagesLabel
        imagesManager.refresh()
    }
    
    private func setUpTable() {
        imagesTableView.register(UINib(nibName: "FilterProgressTableViewCell", bundle: .main),
                                 forCellReuseIdentifier: "FilterProgressTableViewCell")
        imagesTableView.register(UINib(nibName: "ImageTableViewCell", bundle: .main),
                                 forCellReuseIdentifier: "ImageTableViewCell")
        
        imagesTableView.estimatedRowHeight = 100
        imagesTableView.rowHeight = UITableViewAutomaticDimension
        imagesTableView.tableFooterView = UIView()
    }
    
    @IBAction func mirrorAction(_ sender: UIButton) {
        imagesManager.addImage(image: selectedImageView.image!, filter: .mirror)
    }
    
    @IBAction func rotateAction(_ sender: UIButton) {
        imagesManager.addImage(image: selectedImageView.image!, filter: .rotate)
    }
    
    @IBAction func blackAndWiteAction(_ sender: UIButton) {
        imagesManager.addImage(image: selectedImageView.image!, filter: .blackAndWhite)
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
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return tableView.cellForRow(at: indexPath) is ImageTableViewCell ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let imageObject = self.imagesManager.fetchedResultsController.object(at: indexPath)
        let image = UIImage.init(data: imageObject.imageData!)
        
        let controller = UIAlertController.init(title: "Use image to:", message: nil, preferredStyle: .actionSheet)
        controller.addAction(
            UIAlertAction(title: "Apply another filter", style: .default, handler: { [weak self, image] _ in
                self?.handleImageSelection(image)
            }))
        controller.addAction(
            UIAlertAction(title: "Delete image", style: .default, handler: { [weak self] _ in
                self?.imagesManager.deleteObject(at: indexPath)
            }))
        controller.addAction(
            UIAlertAction(title: "Save image to library", style: .default, handler: { [weak self, image] _ in
                if let galleryProvider = self?.imageProviders.first as? GalleryImageProvider, let filteredImage = image {
                    galleryProvider.saveImageToGallery(image: filteredImage)
                }
            }))
        controller.addAction(UIAlertAction.init(title: "Cancel", style: .destructive))
        self.present(controller, animated: true)
    }
}

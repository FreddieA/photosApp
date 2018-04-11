//
//  ImagesProvider.swift
//  mvPhotosApp
//
//  Created by Mikhail Kirillov on 10/04/2018.
//  Copyright © 2018 Mikhail Kirillov. All rights reserved.
//

import CoreData
import UIKit

class ImagesManager: NSObject {
    
    weak var imagesTableView: UITableView?
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Image> = {
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Image.uid), ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: DataBaseHelper.shared.writerContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    private var ongoingFilterOperations: [NSManagedObjectID : ImageFilterOperation] = [:]
    
    func addImage(image: UIImage, filter: FilterType) {
        let context = fetchedResultsController.managedObjectContext
        let imageObject = NSEntityDescription.insertNewObject(forEntityName: "Image", into: context) as! Image
        imageObject.uid = UUID.init().uuidString
        
        let operation = ImageFilterOperation(filterToApply: filter, originalImage: image)
        operation.completionBlock = { [weak self, imageObject] in
            self?.filterCompleted(imageObject: imageObject)
        }
        
        ongoingFilterOperations[imageObject.objectID] = operation
        operation.start()
        
        do {
            try context.save()
        } catch {
            debugPrint("Unexpected error occured: \(error)")
        }
    }
    
    private func filterCompleted(imageObject: Image) {
        
        if let imageData = ongoingFilterOperations[imageObject.objectID]?.resultingImageData {
            imageObject.imageData = imageData
            
            do {
                try DataBaseHelper.shared.writerContext.save()
            } catch {
                debugPrint("Unexpected error occured: \(error)")
            }
        }
        ongoingFilterOperations.removeValue(forKey: imageObject.objectID)
        
        if let indexPath = fetchedResultsController.indexPath(forObject: imageObject) {
            DispatchQueue.main.async {
                self.imagesTableView?.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    func refresh() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            debugPrint("Unexpected error occured: \(error)")
        }
    }
}

extension ImagesManager: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        guard let tableView = imagesTableView else {
            return
        }
        DispatchQueue.main.async {
            switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .none)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .none)
            case .update:
                tableView.reloadRows(at: [indexPath!], with: .none)
            case .move:
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            }
        }
    }
}

extension ImagesManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "ImageTableViewCell")
        
        let image = fetchedResultsController.object(at: indexPath)
        if let operation = ongoingFilterOperations[image.objectID] {
            operation.progressCallback = { [weak cell] operation in
                cell?.textLabel?.text = "\(operation.progress)"
            }
        } else if let data = image.imageData {
            cell.imageView?.image = UIImage(data: data)
        }
        return cell
    }
}



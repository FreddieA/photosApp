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
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Image.uid), ascending: true)]
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: DataBaseHelper.shared.writerContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }()

    private var ongoingFilterOperations: [NSManagedObjectID : ImageFilterOperation] = [:]

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

extension ImagesManager: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}



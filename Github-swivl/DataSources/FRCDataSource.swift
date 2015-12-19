//
//  FRCDataSource.swift
//  Github-swivl
//
//  Created by Nickolay Sheika on 19.12.15.
//  Copyright © 2015 Nickolay Sheika. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol CellProtocol {
    func updateWithModel(model: AnyObject)
}


class FRCDataSource: NSObject {
    
    // MARK: - Variables
    
    weak var tableView: UITableView?
    let fetchedResultsController: NSFetchedResultsController
    let cellReuseIdentifier: String
    
    
    // MARK: - Init
    
    init(tableView: UITableView?, fetchedResultsController: NSFetchedResultsController, cellReuseIdentifier: String) {
        self.tableView = tableView
        self.fetchedResultsController = fetchedResultsController
        self.cellReuseIdentifier = cellReuseIdentifier
        super.init()

        fetchedResultsController.delegate = self
        fetch()
    }
    
    // MARK: - Public
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> NSManagedObject {
        return self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
    }
    
    // MARK: - Private
    
    private func fetch() {
        do {
            try self.fetchedResultsController.performFetch()
        }
        catch {
            print("Failed FRC fetch:\(error)")
        }
    }
    
}

extension FRCDataSource: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections != nil ? fetchedResultsController.sections!.count : 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! CellProtocol
        let model = self.fetchedResultsController.objectAtIndexPath(indexPath)
        cell.updateWithModel(model)
        
        return cell as! UITableViewCell
    }
}

extension FRCDataSource: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView?.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView?.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        guard let tableView = tableView else {
            return
        }
        
        switch type {
        case .Delete : tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        case .Insert : tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        case .Move :
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        case .Update : tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
}

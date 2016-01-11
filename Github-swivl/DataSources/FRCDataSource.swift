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
    typealias T
    
    static func cellReuseIdentifier() ->  String
    func updateWithModel(model: T)
}

extension CellProtocol {
    static func cellReuseIdentifier() ->  String {
        return String(self)
    }
}


class FRCDataSource<CellType: CellProtocol>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    // MARK: - Variables
    
    weak var tableView: UITableView?
    let fetchedResultsController: NSFetchedResultsController
    
    
    // MARK: - Init
    
    init(tableView: UITableView?, fetchedResultsController: NSFetchedResultsController) {
        self.tableView = tableView
        self.fetchedResultsController = fetchedResultsController
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
    
    // MARK: - UITableViewDataSource
    
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
        let reuseIdentifier = CellType.cellReuseIdentifier()
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CellType
        
        if let model = self.fetchedResultsController.objectAtIndexPath(indexPath) as? CellType.T {
            cell.updateWithModel(model)
        }
        
        return cell as! UITableViewCell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
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

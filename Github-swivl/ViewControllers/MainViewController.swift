//
//  MainViewController.swift
//  Github-swivl
//
//  Created by Nickolay Sheika on 19.12.15.
//  Copyright © 2015 Nickolay Sheika. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import BNRCoreDataStack

class MainViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Variables
    
    var coreDataStack: CoreDataStack!
    var dataSource: FRCDataSource<UserTableViewCell>!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        let loader = Loader<User>(context: coreDataStack.newBackgroundWorkerMOC())
        loader.load(page: 0, count: 100) { error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error!.message(), preferredStyle: .Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }

        buildDataSource()
    }
    
    
    // MARK: - Private
    
    private func buildDataSource() {
        let factory = DataSourceFactory<User>(
            tableView: tableView,
            context: coreDataStack.mainQueueContext
        )
        dataSource = factory.buildFRCDataSource(WithSortBy: "remoteID", ascending: true)
        
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}



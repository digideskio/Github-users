//
//  DataSourceFactory.swift
//  Github-swivl
//
//  Created by Nickolay Sheika on 19.12.15.
//  Copyright © 2015 Nickolay Sheika. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import EasyMapping

class DataSourceFactory<T: EKManagedObjectModel> {
    
    // MARK: - Variables
    
    let context: NSManagedObjectContext
    let cellReuseIdentifier: String
    weak var tableView: UITableView?
    
    
    // MARK: - Init
    
    init(tableView: UITableView?, cellReuseIdentifier:String, context: NSManagedObjectContext) {
        self.tableView = tableView
        self.context = context
        self.cellReuseIdentifier = cellReuseIdentifier
    }
    
    // MARK: - Public
    
    func buildFRCDataSource(WithSortBy sortBy: String, ascending: Bool) -> FRCDataSource {
        let frcFactory = FRCFactory<T>(context: context)
        let frc = frcFactory.buildFRC(WithSortBy: sortBy, ascending: ascending)
        
        return FRCDataSource(tableView: tableView, fetchedResultsController: frc, cellReuseIdentifier: cellReuseIdentifier)
    }
}
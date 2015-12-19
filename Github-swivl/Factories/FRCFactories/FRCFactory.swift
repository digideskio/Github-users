//
//  UserFRCFactory.swift
//  Github-swivl
//
//  Created by Nickolay Sheika on 19.12.15.
//  Copyright © 2015 Nickolay Sheika. All rights reserved.
//

import Foundation
import CoreData
import EasyMapping

class FRCFactory<T: EKManagedObjectModel> {

    // MARK: - Variables
    
    let context: NSManagedObjectContext
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public
    
    func buildFRC(WithSortBy sortBy: String, ascending: Bool) -> NSFetchedResultsController {
        let sortDescriptor = NSSortDescriptor(key: sortBy, ascending: ascending)
        
        let request = NSFetchRequest(entityName: String(T))
        request.fetchBatchSize = 20
        request.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
}

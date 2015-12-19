//
//  User+CoreDataProperties.swift
//  
//
//  Created by Nickolay Sheika on 19.12.15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var remoteID: NSNumber?
    @NSManaged var login: String?
    @NSManaged var avatarURL: String?
    @NSManaged var htmlURL: String?

}

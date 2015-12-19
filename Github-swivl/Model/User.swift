//
//  User.swift
//  
//
//  Created by Nickolay Sheika on 19.12.15.
//
//

import Foundation
import CoreData
import EasyMapping

class User: EKManagedObjectModel {

    // MARK: - Mapping
    
    override class func objectMapping() -> EKManagedObjectMapping {
        return EKManagedObjectMapping(forEntityName: String(self)) { mapping in
            mapping.mapKeyPath("login", toProperty: "login")
            mapping.mapKeyPath("html_url", toProperty: "htmlURL")
            mapping.mapKeyPath("avatar_url", toProperty: "avatarURL")
            mapping.mapKeyPath("id", toProperty: "remoteID")
            mapping.primaryKey = "remoteID"
        }
    }
}

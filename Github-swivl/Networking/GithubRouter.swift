//
//  GithubRouter.swift
//  Github-swivl
//
//  Created by Nickolay Sheika on 19.12.15.
//  Copyright © 2015 Nickolay Sheika. All rights reserved.
//

import Foundation
import EasyMapping

class GithubRouter {
    class func endPoint<T: EKManagedObjectModel>(type: T.Type) -> String? {
        switch type {
        case is User.Type:
            return "users"
        default:
            return nil
        }
    }
}
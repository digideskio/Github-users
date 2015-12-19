//
//  AppDelegate.swift
//  Github-swivl
//
//  Created by Nickolay Sheika on 14.12.15.
//  Copyright © 2015 Nickolay Sheika. All rights reserved.
//

import UIKit
import CoreData
import BNRCoreDataStack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        do {
            let rootController = self.window!.rootViewController as! MainViewController
            rootController.coreDataStack = try CoreDataStack.constructInMemoryStack(withModelName: "Github_swivl")
        } catch {
            print(error)
        }
        
        return true
    }
    
}


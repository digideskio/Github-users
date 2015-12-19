//
//  BaseTableViewCell.swift
//  Github-swivl
//
//  Created by Nickolay Sheika on 19.12.15.
//  Copyright © 2015 Nickolay Sheika. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewCell: UITableViewCell, CellProtocol {
    func updateWithModel(model: AnyObject) {
        // override in subclass
    }
    
    class func reuseIdentifier() -> String {
        return String(self)
    }
}
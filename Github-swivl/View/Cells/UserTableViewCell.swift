//
//  UserTableViewCell.swift
//  Github-swivl
//
//  Created by Nickolay Sheika on 19.12.15.
//  Copyright © 2015 Nickolay Sheika. All rights reserved.
//

import Foundation
import UIKit
import Haneke

class UserTableViewCell: BaseTableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userURLLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    override func updateWithModel(model: AnyObject) {
        guard let model = model as? User else {
            return
        }
        
        userNameLabel.text = model.login
        userURLLabel.text = model.htmlURL
        
        if let avatarURL = model.avatarURL, imageURL = NSURL(string: avatarURL) {
            userAvatarImageView.hnk_setImageFromURL(imageURL)
        }
    }
    
    override func prepareForReuse() {
        userAvatarImageView.image = nil
    }
}

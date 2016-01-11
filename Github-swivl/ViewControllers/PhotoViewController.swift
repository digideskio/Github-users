//
//  PhotoViewController.swift
//  Github-swivl
//
//  Created by Nickolay Sheika on 19.12.15.
//  Copyright © 2015 Nickolay Sheika. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: - Variables
    
    var photoURL: String?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        guard let photoURL = photoURL, let url = NSURL(string: photoURL) else {
            NSException(name: NSInvalidArgumentException, reason: "PhotoViewController should have valid photoURL!", userInfo: nil).raise()
            return
        }
        imageView.hnk_setImageFromURL(url)
    }
}
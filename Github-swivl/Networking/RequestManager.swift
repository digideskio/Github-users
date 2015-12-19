//
//  RequestManager.swift
//  Github-swivl
//
//  Created by Nickolay Sheika on 19.12.15.
//  Copyright © 2015 Nickolay Sheika. All rights reserved.
//

import Foundation
import Alamofire

class RequestManager {
    
    typealias RequestManagerCompletionHandler = ((response: Response<AnyObject, NSError>) -> ())

    // MARK: - Variables
    
    let baseURL: String
    
    
    // MARK: - Init
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    
    // MARK: - Public
    
    func getRequest(WithEndPoint endPoint: String, parameters: [String: AnyObject]?, completion: RequestManagerCompletionHandler?) {
        let url = baseURL.stringByAppendingString(endPoint)
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseJSON { response in
            completion?(response: response)
        }
    }
}
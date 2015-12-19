//
//  UsersLoader.swift
//  Github-swivl
//
//  Created by Nickolay Sheika on 19.12.15.
//  Copyright © 2015 Nickolay Sheika. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import EasyMapping

enum ResponseError: ErrorType {
    case ResponseErrorParsing
    case ResponseErrorContextSave
    case ResponseErrorAPI(error: NSError?)
    
    func message() -> String {
        switch self {
        case .ResponseErrorContextSave:
            return "Error when saving data."
        case .ResponseErrorParsing:
            return "Error parsing api response."
        case .ResponseErrorAPI:
            return "Error when connecting to github."
        }
    }
}


class Loader<T: EKManagedObjectModel> {
    
    typealias LoaderCompletionHandler = (error: ResponseError?) -> ()
    
    // MARK: - Public
    
    class func load(page page: Int, count: Int, context: NSManagedObjectContext, completion: LoaderCompletionHandler?) {
        guard let endPoint = GithubRouter.endPoint(T) else {
            NSException(name:NSInternalInconsistencyException, reason:"Cannot find endpoint for model!", userInfo:nil).raise()
            return
        }
        
        let requestManager = RequestManager(baseURL: GithubDefinitions.GithubURL)

        let params = ["page" : page, "per_page" : count]

        requestManager.getRequest(WithEndPoint: endPoint, parameters: params) { response in
            guard response.result.isSuccess else {
                completion?(error: ResponseError.ResponseErrorAPI(error: response.result.error))
                return
            }
            
            guard let resultArray = response.result.value as? [AnyObject] else {
                completion?(error: ResponseError.ResponseErrorParsing)
                return
            }
            
            context.performBlock {
                let mapping = T.objectMapping()
                let fetchRequest = NSFetchRequest(entityName: mapping.entityName)
                
                EKManagedObjectMapper.syncArrayOfObjectsFromExternalRepresentation(
                    resultArray,
                    withMapping: mapping,
                    fetchRequest: fetchRequest,
                    inManagedObjectContext: context
                )
                
                do {
                    try context.save()
                }
                catch {
                    completion?(error: ResponseError.ResponseErrorContextSave)
                }
            }
        }
    }
}

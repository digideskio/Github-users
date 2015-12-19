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
    
    // MARK: - Variables
    
    let context: NSManagedObjectContext
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public
    
    func load(page page: Int, count: Int, completion: LoaderCompletionHandler?) {
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
            
            self.updateContextWithObjects(resultArray, completion: completion)
        }
    }
    
    // MARK: - Private 
    
    private func updateContextWithObjects(objects: [AnyObject], completion: LoaderCompletionHandler?) {
        context.performBlock {
            let mapping = T.objectMapping()
            let fetchRequest = NSFetchRequest(entityName: mapping.entityName)
            
            EKManagedObjectMapper.syncArrayOfObjectsFromExternalRepresentation(
                objects,
                withMapping: mapping,
                fetchRequest: fetchRequest,
                inManagedObjectContext: self.context
            )
            
            do {
                try self.context.save()
                completion?(error: nil)
            }
            catch {
                completion?(error: ResponseError.ResponseErrorContextSave)
            }
        }
    }
}

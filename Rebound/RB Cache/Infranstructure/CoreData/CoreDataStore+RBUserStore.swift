//
//  CoreDataUserCache+RBUserStore.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import Foundation
import CoreData

extension CoreDataStore: RBUserStore {
    public func deleteRBUser(rbUserId: String, completion: @escaping DeleteCompletion) {
        deleteItem(objectId: rbUserId, completion: completion)
    }

    public func retrieve(completion: @escaping RBUserStore.RetrieveCompletion) {
        perform { context in
            completion(Result {
                let request = NSFetchRequest<ManagedRBUser>(entityName: "ManagedRBUser")
               // request.predicate = NSPredicate(format:"self IN urls")
                //request.returnsObjectsAsFaults = false
                let result = try context.fetch(request)
                
                return result.map { managedRBUser in
                    var user = LocalRBUser(userId:managedRBUser.objectID.uriRepresentation().absoluteString, userName: managedRBUser.username!, createdDate: managedRBUser.createdDate!)
                    user.urls = managedRBUser.urls!.map { item in
                       let item = item as! ManagedRBUrl
                        return LocalRBUrl(urlId: item.objectID.uriRepresentation().absoluteString, isPrimary: item.isprimary, createdDate: item.createdDate!, url: item.uri!.absoluteString, state: item.state, viewedLastModified: item.viewedlastmodified, lastModified: item.lastmodified!)
                    }
                    return user
                }
            })
        }
    }
}

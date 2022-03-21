//
//  CoreDataUserCache+RBUserStore.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import Foundation
import CoreData

extension CoreDataStore: RBUserStore {
    public func retrieve(userId: String, completion: @escaping (Result<LocalRBUser?, Error>) -> ()) {
        perform { context in
            completion(Result {
                if let objectIDURL = URL(string: userId) {
                    let coordinator: NSPersistentStoreCoordinator = context.persistentStoreCoordinator!
                    let managedObjectID = coordinator.managedObjectID(forURIRepresentation: objectIDURL)!
                    
                    let result = context.object(with: managedObjectID) as! ManagedRBUser
                    var localuser = LocalRBUser(userId: result.objectID.uriRepresentation().absoluteString, userName: result.username!, createdDate: result.createdDate!)
                    localuser.urls = result.urls!.map { item in
                        let item = item as! ManagedRBUrl
                         return LocalRBUrl(urlId: item.objectID.uriRepresentation().absoluteString, isPrimary: item.isprimary, createdDate: item.createdDate!, url: item.uri!.absoluteString, state: item.state, viewedLastModified: item.viewedlastmodified, lastModified: item.lastmodified!)
                     }
                    return localuser
                   }
                return nil
            })
        }
    }
    
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
                    }.sorted(by: { lhs, rhs in
                        lhs.lastModified > rhs.lastModified
                    })
                    return user
                }.sorted { lhs, rhs in
                    if let lFirst = lhs.urls.first, let rFirst = rhs.urls.first {
                        return lFirst.lastModified > rFirst.lastModified
                    }
                    if lhs.urls.first != nil {
                        return true
                    } else {
                        return false
                    }
                }
            })
        }
    }
}

//
//  CoreDataUserCache+RBUserStore.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import Foundation
import CoreData

extension CoreDataStore: RBUserStore {
    
    public func retrieve(completion: @escaping RBUserStore.RetrieveCompletion) {
        perform { context in
            completion(Result {
                let result = try context.fetch(NSFetchRequest<ManagedRBUser>(entityName: "ManagedRBUser"))
                
                return result.map { managedRBUser in
                    return LocalRBUser(userId:managedRBUser.objectID.uriRepresentation().absoluteString, userName: managedRBUser.username!, createdDate: managedRBUser.createdDate!)
                }
            })
        }
    }
}

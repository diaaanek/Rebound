//
//  CoreDataRBUrlStore+RBUrlClient.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import Foundation
import CoreData

extension CoreDataStore: RBUrlStore {
    
    var entityName: String {
        return "ManagedRBUrl"
    }
    public func insert(rbUrl local: LocalRBUrl, userId: String, completion: @escaping (Result<LocalRBUrl, Error>) -> () ) {
        perform { [weak self] context in
            completion( Result {
                guard let strongSelf = self else {
                    fatalError()
                }
                let managedObject = context.object(with: strongSelf.objectId(stringId: userId)!) as! ManagedRBUser
                let rbUrl = ManagedRBUrl(context: context)
                rbUrl.createdDate = local.createdDate
                rbUrl.isprimary = local.isPrimary
                rbUrl.state = Int32(local.state)
                rbUrl.uri = URL(string:local.url)
                rbUrl.user = managedObject
                try context.save()
                let newItem = LocalRBUrl(urlId: rbUrl.objectID.uriRepresentation().absoluteString, isPrimary: local.isPrimary, createdDate: local.createdDate, url: local.url, state: local.state)
                
                return newItem
            })
        }
    }
    
    public func insert(rbUrl item: [LocalRBUrl], user: LocalRBUser, timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            completion( Result {
                
                let rbUser = ManagedRBUser(context: context)
                rbUser.createdDate = timestamp
                rbUser.username = user.userName
                try context.save()
                let newUser = LocalRBUser(userId: rbUser.objectID.uriRepresentation().absoluteString, userName: user.userName, createdDate: timestamp)
                _ = item.map { local in
                    let rbUrl = ManagedRBUrl(context: context)
                    rbUrl.createdDate = local.createdDate
                    rbUrl.isprimary = local.isPrimary
                    rbUrl.state = Int32(local.state)
                    rbUrl.uri = URL(string:local.url)
                    rbUrl.user = rbUser
                }
                try context.save()
                return newUser
            }
            )
        }
    }
    
    private func retrieve(userId: String, count: Int, offset: Int, primary: Bool?, completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result{
                let request = NSFetchRequest<ManagedRBUrl>(entityName: self.entityName)
                let objectId = self.objectId(stringId: userId)
                let user = context.object(with: objectId!) as! ManagedRBUser
                var query = "user.username == %@"
                if let p = primary {
                    query += " AND isprimary == \(p)"
                }
                request.fetchLimit = count
                request.fetchOffset = offset
                request.predicate = NSPredicate(format: query, user.username!)
                request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
                let result = try context.fetch(request)
                return result.map { managed in
                    return LocalRBUrl(urlId: managed.objectID.uriRepresentation().absoluteString, isPrimary: managed.isprimary, createdDate: managed.createdDate!, url: managed.uri!.absoluteString, state: Int(managed.state))
                }
            })
        }
    }
    
    public func retrieve(userId: String, count: Int, offset: Int, completion: @escaping RetrievalCompletion) {
        retrieve(userId: userId, count: count, offset: offset,primary: nil, completion: completion)
    }
    
    public func retrievePrimary(userId: String, completion: @escaping RetrievalCompletion) {
        retrieve(userId: userId, count: 10, offset: 0, primary: true, completion: completion)
    }
}

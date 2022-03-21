//
//  CoreDataRBUrlStore+RBUrlClient.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import Foundation
import CoreData

extension CoreDataStore: RBUrlStore {
    public func merge(rbUrl item: LocalRBUrl, completion: @escaping (Result<LocalRBUrl, Error>) -> ()) {
        perform { [weak self] context in
            completion( Result {
                guard let strongSelf = self else {
                    fatalError()
                }
                let managedObject = context.object(with: strongSelf.objectId(stringId: item.urlId)!) as! ManagedRBUrl
                managedObject.isprimary = item.isPrimary
                managedObject.state = item.state
                managedObject.uri = URL(string:item.url)
                managedObject.lastmodified = item.lastModified
                managedObject.viewedlastmodified = item.viewedLastModified
                try context.save()
                return item
            })
        }
    }
    
    
    var entityName: String {
        return "ManagedRBUrl"
    }
    public func deleteRBUrl(rbUrl urlId: String, completion: @escaping DeletionCompletion) {
        deleteItem(objectId: urlId, completion: completion)
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
                rbUrl.state = local.state
                rbUrl.uri = URL(string:local.url)
                rbUrl.user = managedObject
                try context.save()
                let newItem = LocalRBUrl(urlId: rbUrl.objectID.uriRepresentation().absoluteString, isPrimary: local.isPrimary, createdDate: local.createdDate, url: local.url, state: local.state, viewedLastModified: rbUrl.viewedlastmodified, lastModified: rbUrl.lastmodified!)
                
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
                for local in item {
                    let rbUrl = ManagedRBUrl(context: context)
                    rbUrl.createdDate = local.createdDate
                    rbUrl.lastmodified = local.lastModified
                    rbUrl.viewedlastmodified = local.viewedLastModified
                    rbUrl.isprimary = local.isPrimary
                    rbUrl.state = local.state
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
                    return LocalRBUrl(urlId: managed.objectID.uriRepresentation().absoluteString, isPrimary: managed.isprimary, createdDate: managed.createdDate!, url: managed.uri!.absoluteString, state: managed.state, viewedLastModified: managed.viewedlastmodified, lastModified: managed.lastmodified!)
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

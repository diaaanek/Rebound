//
//  RBUrlStore.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//
import Foundation


public protocol RBUrlStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<LocalRBUser, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<[LocalRBUrl]?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    /// // not used
//    func deleteRBUrl(rbUrl urlId: String, completion: @escaping DeletionCompletion)
//    func retrievePrimary(userId :String,completion: @escaping RetrievalCompletion)
//    func retrieve(userId :String, count:Int, offset: Int, completion: @escaping RetrievalCompletion)

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
   // func insert(rbUrl item: LocalRBUrl,userId :String, completion: @escaping  (Result<LocalRBUrl, Error>) -> ())
    
    // Creates a User and assocaites the LocalRBUrl.
    func insert(rbUrl item: [LocalRBUrl],user :LocalRBUser, timestamp: Date, completion: @escaping InsertionCompletion)
    
    // Merge updates the stored rbUrl to the provided one using the same id. Mainly used to update isShown property.
    func merge(rbUrl item: LocalRBUrl, completion: @escaping  (Result<LocalRBUrl, Error>) -> ())

    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    
}

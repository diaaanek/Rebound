//
//  RBUserStore.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import Foundation

public protocol RBUserStore {
    typealias RetrieveCompletion = (Result<[LocalRBUser]?,Error>) -> ()
    typealias DeleteCompletion = (Result<Void,Error>) -> ()
    
    func deleteRBUser(rbUserId: String, completion: @escaping DeleteCompletion)
    func deleteRBUser(completion: @escaping DeleteCompletion)

    func replaceRBUser(rbUserId: String, localRbUser: LocalRBUser,completion: @escaping (Result<LocalRBUser?,Error>)->())

    // returns all users 
    func retrieve(completion:@escaping RetrieveCompletion)
   // func retrieve(userId: String, completion:@escaping (Result<LocalRBUser?,Error>) -> ())


}

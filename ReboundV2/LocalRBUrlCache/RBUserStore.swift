//
//  RBUserStore.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import Foundation

public protocol RBUserStore {
    typealias RetrieveCompletion = (Result<[LocalRBUser]?,Error>) -> ()
    // typealias DeleteCompletion = (Result<Void,Error>) -> ()
    
    func retrieve(completion:@escaping RetrieveCompletion)
}

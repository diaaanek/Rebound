//
//  EditUserDataStoreAdapter.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/12/22.
//

import Foundation
import ReboundiOS
import Rebound
class EditUserDataStoreAdapter : EditRBUserDelegate {
    let rbUserStore : RBUserStore
    let rbUrlStore: RBUrlStore
    
    init(rbUserStore: RBUserStore, rbUrlStore: RBUrlStore) {
        self.rbUserStore = rbUserStore
        self.rbUrlStore = rbUrlStore
    }
    
    func createdNewUser(name: String, urls: [String]) {
        self.rbUrlStore.insert(rbUrl: urls.map({ urlString in
            LocalRBUrl(urlId: "", isPrimary: true, createdDate: Date(), url: urlString, state: 0)
        }), user: LocalRBUser(userId: "", userName: name, createdDate: Date()), timestamp: Date()) { result in
            
        }
    }
    
    func editExistingUser(userId: String, name: String, urls: [String]) {
        fatalError("Not implemented")
    }
    
    func deleteUser(userId: String?) {
        if let userId = userId {
            self.rbUserStore.deleteRBUser(rbUserId: userId) { result in
                
            }
        }
    }
    
    
}

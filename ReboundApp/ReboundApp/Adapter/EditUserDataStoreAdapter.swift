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
    let editNavigation : EditControllerNavigation
    var refreshData : (()->())?
    init(rbUserStore: RBUserStore, rbUrlStore: RBUrlStore, editNav: EditControllerNavigation) {
        self.rbUserStore = rbUserStore
        self.rbUrlStore = rbUrlStore
        self.editNavigation = editNav
    }
    
    func createdNewUser(name: String, urls: [EditUrl], creationDate: Date) {
        self.rbUrlStore.insert(rbUrl: urls.map({ urlString in
            LocalRBUrl(urlId: "", isPrimary: true, createdDate: creationDate, url: urlString.urlString, state: urlString.isShownOnProfile, viewedLastModified: creationDate, lastModified: creationDate)
        }), user: LocalRBUser(userId: "", userName: name, createdDate: creationDate), timestamp: Date()) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                print("Failed to save")
            case .success(_):
                self?.refreshData?()
                self?.editNavigation.navigateToSuccessSave()
            }
        }
    }
    
    func editExistingUser(userId: String, name: String, urls: [EditUrl]) {
        fatalError("Not implemented")
    }
    
    func deleteUser(userId: String?) {
        if let userId = userId {
            self.rbUserStore.deleteRBUser(rbUserId: userId) {[weak self] result in
                self?.refreshData?()
                self?.editNavigation.navigateToSuccessDelete()
            }
        } else {
            self.editNavigation.navigateToSuccessDelete()
        }
    }
    
    
}

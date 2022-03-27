//
//  EditUserDataStoreAdapter.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/12/22.
//

import Foundation
import ReboundiOS
import Rebound
class CreateUserDataStoreAdapter : EditRBUserDelegate {
    let rbUserStore : RBUserStore
    let rbUrlStore: RBUrlStore
    let editNavigation : EditControllerNavigation
    var refreshData : (()->())?
    init(rbUserStore: RBUserStore, rbUrlStore: RBUrlStore, editNav: EditControllerNavigation) {
        self.rbUserStore = rbUserStore
        self.rbUrlStore = rbUrlStore
        self.editNavigation = editNav
    }
    
    func result(items: [EditItemController], creationDate: Date) {
        let name = items.first!
        let urls : [EditItemController] = items[1...].compactMap { item in
            if item.displayText.isEmpty {
                return nil
            }
            return item
        }
        self.rbUrlStore.insert(rbUrl: urls.map({ urlString in
            LocalRBUrl(urlId: "", isPrimary: true, createdDate: creationDate, url: urlString.displayText, state: urlString.isShownOnProfile, pageData: urlString.pageData!, viewedLastModified: creationDate, lastModified: creationDate)
        }), user: LocalRBUser(userId: "", userName: name.displayText, createdDate: creationDate), timestamp: creationDate) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .failure(let error):
                break
            case .success(_):
                self?.refreshData?()
                self?.editNavigation.navigateToSuccessSave()
            }
        }
    }
    
    func editExistingUser(userId: String, items: [EditItemController]) {
        let name = items.first!
        let urls = items[1...]
        self.rbUserStore.deleteRBUser(rbUserId: userId) { result in
            switch result {
            case .success():
                self.result(items: items, creationDate: Date())
            case .failure(let error):
                fatalError("Error deleting")
            }
        }

    }
    
    func delete(userId: String?) {
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

class EditUserDataStoreAdapter: CreateUserDataStoreAdapter {
    let userId : String
    init(userId: String, rbUserStore: RBUserStore, rbUrlStore: RBUrlStore, editNav: EditControllerNavigation) {
        self.userId = userId
        super.init(rbUserStore: rbUserStore, rbUrlStore: rbUrlStore, editNav: editNav)
    }
    
    
    override func result(items: [EditItemController], creationDate: Date) {
        let name = items.first!
        let urls : [EditItemController] = items[1...].compactMap { item in
            if item.displayText.isEmpty {
                return nil
            }
            return item
        }
        var localUser = LocalRBUser(userId: userId, userName: name.displayText, createdDate: creationDate)
        localUser.urls = urls.map({ urlString in
            LocalRBUrl(urlId: "", isPrimary: true, createdDate: creationDate, url: urlString.displayText, state: urlString.isShownOnProfile, pageData: urlString.pageData!, viewedLastModified: creationDate, lastModified: creationDate)
        })
        
        self.rbUserStore.replaceRBUser(rbUserId: userId, localRbUser: localUser) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .failure(let error):
                break
            case .success(_):
                self?.refreshData?()
                self?.editNavigation.navigateToSuccessSave()
            }
        }
    }
}



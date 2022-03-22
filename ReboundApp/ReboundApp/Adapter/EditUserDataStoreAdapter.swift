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
        }), user: LocalRBUser(userId: "", userName: name, createdDate: creationDate), timestamp: creationDate) { [weak self] result in
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
        self.rbUserStore.deleteRBUser(rbUserId: userId) { result in
            switch result {
            case .success():
                self.createdNewUser(name: name, urls: urls, creationDate: Date())
            case .failure(let error):
                fatalError("Error deleting")
            }
        }
      /*  self.rbUserStore.retrieve(userId: userId) { [weak self] result in
            switch result {
            case .success(.some(let user)):
                guard let self = self else {
                    return
                }
                var urlDict = [String: LocalRBUrl]()
                user.urls.forEach { local in
                    urlDict[local.url] = local
                }
                let dispatchGroup = DispatchGroup()
                let today = Date()
                for editUrl in urls {
                    dispatchGroup.enter()
                    if let localUrl = urlDict[editUrl.urlString] {
                        self.rbUrlStore.merge(rbUrl: LocalRBUrl(urlId: localUrl.urlId, isPrimary: localUrl.isPrimary, createdDate: localUrl.createdDate, url: editUrl.urlString, state: editUrl.isShownOnProfile, viewedLastModified: today, lastModified: today)) { result in
                            dispatchGroup.leave()
                        }
                    } else {
                        self.rbUrlStore.insert(rbUrl: LocalRBUrl(urlId: "", isPrimary: true, createdDate: today, url: editUrl.urlString, state: editUrl.isShownOnProfile, viewedLastModified: today, lastModified: today), userId: userId) { result in
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self.refreshData?()
                    self.editNavigation.navigateToSuccessSave()
                }
                
            case .failure(let error):
                fatalError(error.localizedDescription)
                break
            case .success(.none):
                fatalError("User Not found")
            }
        }
       */
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

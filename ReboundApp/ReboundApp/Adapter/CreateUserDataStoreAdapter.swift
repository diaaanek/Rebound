//
//  EditUserDataStoreAdapter.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/12/22.
//

import Foundation
import ReboundiOS
import Rebound
import Swiftagram
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
        if let secretData = UserDefaults().data(forKey:"secret") {
            let secret = try! Secret.decoding(secretData)
            var user = RBUser(userId: "", userName: name.displayText, createdDate: creationDate)
            user.urls = urls.enumerated().map({ (index, element) in
                RBUrl(urlId: "", isPrimary: true, createdDate: creationDate, url: element.displayText, state: element.isShownOnProfile, lastModified: creationDate, viewedLastModified: creationDate, urlStatusId: nil)
            })
            RemoteSaveRbUser(client: UrlSessionHttpClient(), identity: secret.identifier).save(rbuser: user) { result in
                switch result {
                case .success(let list):
                self.rbUrlStore.insert(rbUrl: urls.enumerated().map({ index,element in
                    LocalRBUrl(urlId: "", isPrimary: true, createdDate: creationDate, url: element.displayText, state: element.isShownOnProfile, viewedLastModified: creationDate, lastModified: creationDate, urlStatusId: list[index])
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
                case .failure(let error):
                    print(error)
                }
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
    
    func delete(userId: String?, items: [EditItemController]) {
        if let userId = userId {
            let deleteCompletion = DeleteUrlStatus(httpClient: UrlSessionHttpClient())
           
            self.rbUserStore.retrieve(userId: userId) { result in
                switch result {
                case .success(let user):
                    for url in user!.urls {
                        deleteCompletion.deleteUrlStatus(urlStatusId: String(url.urlStatusId!)) { result in
                        }
                    }
                case .failure(let error):
                    print(error)
                }
               
            }
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
            LocalRBUrl(urlId: "", isPrimary: true, createdDate: creationDate, url: urlString.displayText, state: urlString.isShownOnProfile, viewedLastModified: creationDate, lastModified: creationDate, urlStatusId: nil)
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



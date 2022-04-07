//
//  CreateAdapterNavigation.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/26/22.
//

import Foundation
import Rebound
import ReboundiOS
import UIKit

class CreateNameAdapterNavigation: EditRBUserDelegate {
    let nav : UINavigationController
    let coreData:CoreDataStore
    let refresh : ()->()
    init(nav: UINavigationController, coreDate: CoreDataStore, refresh:@escaping ()->()) {
        self.nav = nav
        self.coreData = coreDate
        self.refresh = refresh
    }
    
    func result(items: [EditItemController], creationDate: Date) {
        if let nameItem = items.first {
            let singleUrl =  CreateSingleUrlComposer(coreData: self.coreData).composeCreateViewController(nameString: nameItem.displayText, navigationController: nav, refreshData: refresh)
        self.nav.pushViewController(singleUrl, animated: true)
        }
    }
    
    func editExistingUser(userId: String, items: [EditItemController]) {
        fatalError("Should not be called")
    }
    
    func delete(userId: String?, items: [EditItemController]) {
        fatalError("Should not be called")
    }
    
    
}

class CreateUrlAdapterNavigation: EditRBUserDelegate {
    let nav : UINavigationController
    let nameItem : String
    let coreDataStore : CoreDataStore
    let refresh: ()->()
    init(nav: UINavigationController, nameItem: String, coreDataStore: CoreDataStore, refreshData: @escaping()->()) {
        self.nav = nav
        self.nameItem = nameItem
        self.coreDataStore = coreDataStore
        self.refresh = refreshData
    }
    
    func result(items: [EditItemController], creationDate: Date) {
        if let urlItem = items.first {
            let createController =  CreateEditRbUserComposer().composeCreateViewController(nameString: nameItem, urlString: urlItem.displayText, coreDataStore: coreDataStore, navigationController: nav, refreshData: refresh)
        self.nav.pushViewController(createController, animated: true)
        }
    }
    
    func editExistingUser(userId: String, items: [EditItemController]) {
        fatalError("Should not be called")
    }
    
    func delete(userId: String?, items: [EditItemController]) {
        fatalError("Should not be called")
    }
    
    
}

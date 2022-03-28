//
//  MainNavigationFlow.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 2/24/22.
//

import Foundation
import ReboundiOS
import Rebound
import UIKit

class MainNavigationFlow : MainNavigationItemDelegate {
 
    var navigationController : UINavigationController!
    let cache : CoreDataStore
    var refreshData : (()->())?
    var accountNavigation : AccountNavigation?
    init(coreDateCache: CoreDataStore) {
        self.cache = coreDateCache
    }
    func navigateToAccount() {
        if let accountNavigation = accountNavigation {
            let accountViewController = AccountTableViewComposer(accountNavigation: accountNavigation).makeAccountTableView()
            self.navigationController.present(accountViewController, animated: true)
        }
    }
    func navigateToCreate() {
        let navigation = UINavigationController()
        let createController = CreateNameComposer().composeCreateViewController(coreData: self.cache, navigationController: navigation, refreshData: refreshData)
        navigation.setViewControllers([createController], animated: false)
        self.navigationController.present(navigation, animated: true)
    }

    func navigateToCreate(rbUser: RBUser) {
        let createController = CreateEditRbUserComposer().composeEditRBUserViewController(rbUser: rbUser, coreDataStore: cache, navigationController: self.navigationController, refreshData: refreshData)
        self.navigationController.present(createController, animated: true)
    }
}

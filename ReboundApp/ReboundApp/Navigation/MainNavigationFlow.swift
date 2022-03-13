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
    init(coreDateCache: CoreDataStore) {
        self.cache = coreDateCache
    }

    func navigateToCreate(rbUser: RBUser?) {
        let createController = CreateComposer().composeCreateViewController(rbUser: rbUser, coreDataStore: cache, navigationController: self.navigationController)
        self.navigationController.present(createController, animated: true)
    }
}

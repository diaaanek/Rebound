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
    let detailedFeedComposer : DetailedFeedComposer
    let cache : CoreDataStore
    init(detailFeedComposer: DetailedFeedComposer, coreDateCache: CoreDataStore) {
        self.detailedFeedComposer = detailFeedComposer
        self.cache = coreDateCache
    }
    func didSelectItem(rbUser: RBUser) {
        let detailedFeed = detailedFeedComposer.composeDetailedFeed()
        DispatchQueue.main.async {
            self.navigationController.present(detailedFeed, animated: true)
        }
    }
    func navigateToCreate(rbUser: RBUser?) {
        let createController = CreateComposer().composeCreateViewController(rbUser: rbUser, coreDataStore: cache, navigationController: self.navigationController)
        self.navigationController.present(createController, animated: true)
    }
}

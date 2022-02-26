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
    let navigationController : UINavigationController
    let detailedFeedComposer : DetailedFeedComposer
    
    init(navigation: UINavigationController, detailFeedComposer: DetailedFeedComposer) {
        self.navigationController = navigation
        self.detailedFeedComposer = detailFeedComposer
    }
    func didSelectItem(rbUser: RBUser) {
        let detailedFeed = detailedFeedComposer.composeDetailedFeed()
        DispatchQueue.main.async {
            self.navigationController.pushViewController(detailedFeed, animated: true)
        }
    }
}

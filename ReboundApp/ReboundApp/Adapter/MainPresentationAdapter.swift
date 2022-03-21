//
//  MainPresentationAdapter.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 2/23/22.
//

import Foundation
import Rebound
import ReboundiOS

class MainPresenationAdapter:  MainView {
    
    public weak var controller : MainViewController?
    let lastOpenedDate: Date
    let mainNavigationFlow : MainNavigationFlow
    init(lastOpenedDate: Date, mainNavigation: MainNavigationFlow) {
        self.lastOpenedDate = lastOpenedDate
        self.mainNavigationFlow = mainNavigation
    }
    
    func display(mainModelView: MainModelView) {
        let (updates, noUpdates) = split(list: mainModelView.rbUser, by: lastOpenedDate)
        controller?.display(recentUpdates:createController(users:updates),  noUpdates: createController(users:noUpdates))
    }
    
    private func createController(users: [RBUser]) -> [MainItemController] {
        return users.map { user in
            let wkLoaderAdapter = WKViewPresenterDataLoaderAdapter()
            let mainItemController = MainItemController(delegate: wkLoaderAdapter, model: user)
            mainItemController.navigationDelegate = mainNavigationFlow
            return mainItemController
        }
    }
    
    private func split(list users: [RBUser],by lastOpened:Date) -> ([RBUser],[RBUser]) {
        var tempRecentUpdates = [RBUser]()
        var tempNoUpdates = [RBUser]()
        
        for user in users {
            if let firstUrl = user.urls.first {
                if firstUrl.viewedLastModified == nil || firstUrl.viewedLastModified!.addingTimeInterval(60*60*24) > lastOpened {
                    tempRecentUpdates.append(user)
                } else {
                    tempNoUpdates.append(user)
                }
            }
        }
        return (tempRecentUpdates,tempNoUpdates)
    }
}

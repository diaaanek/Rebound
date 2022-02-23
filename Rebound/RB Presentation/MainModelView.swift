//
//  MainModelView.swift
//  Rebound
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation

public struct MainModelView {
    
    public let recentUpdates : [RBUser] // users whose first url is created after last opened dated
    public let noUpdates: [RBUser] // all users whose first url is last opened date

    
    public init(users : [RBUser], lastOpened:Date) {
        var tempRecentUpdates = [RBUser]()
        var tempNoUpdates = [RBUser]()
        
        for user in users {
            if let firstUrl = user.urls.first {
                if firstUrl.createdDate > lastOpened {
                    tempRecentUpdates.append(user)
                } else {
                    tempNoUpdates.append(user)
                }
            }
        }
        recentUpdates = tempRecentUpdates
        noUpdates = tempNoUpdates
    }
}

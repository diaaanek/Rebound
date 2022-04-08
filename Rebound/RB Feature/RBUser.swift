//
//  RBUser.swift
//  Rebound
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation

public struct RBUser {
    public let userId : String
    public let userName : String
    public let createdDate : Date
    public var urls : [RBUrl]
    public init(userId: String, userName: String, createdDate: Date) {
        self.userId = userId
        self.userName = userName
        self.createdDate = createdDate
        self.urls = [RBUrl]()
    }
}

extension RBUser {
    
    func getLocalUser() -> LocalRBUser {
        var user = LocalRBUser(userId: "", userName: self.userName, createdDate: self.createdDate)
        user.urls = self.urls.map({ rbUrl in
            return LocalRBUrl(urlId: rbUrl.urlId, isPrimary: rbUrl.isPrimary, createdDate: rbUrl.createdDate, url: rbUrl.url, state: rbUrl.isShown, viewedLastModified: rbUrl.viewedLastModified, lastModified: rbUrl.lastModified, urlStatusId: rbUrl.urlStatusId)
        })
        return user
    }
    func getRemoteUser() -> RemoteRBUser {
        var user = RemoteRBUser(userId: "", userName: self.userName, createdDate: self.createdDate)
        user.urls = self.urls.map({ rbUrl in
            return RemoteRBUrl(urlStatusId: rbUrl.urlStatusId!, isPrimary: rbUrl.isPrimary, createdDate: rbUrl.createdDate, url: rbUrl.url, state: rbUrl.isShown, lastModified: rbUrl.lastModified, viewedLastModified: rbUrl.viewedLastModified)
        })
        return user
    }
}


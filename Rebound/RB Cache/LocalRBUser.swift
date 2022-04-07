//
//  LocalRBUser.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import Foundation

public struct LocalRBUser {
    public let userId : String
    public let userName : String
    public let createdDate : Date
    public var urls : [LocalRBUrl]
    public init(userId: String, userName: String, createdDate: Date) {
        self.userId = userId
        self.userName = userName
        self.createdDate = createdDate
        self.urls = [LocalRBUrl]()
    }
}

extension LocalRBUser {
    public func getRBUser() -> RBUser {

        var user = RBUser(userId: self.userId,
                          userName: self.userName, createdDate: self.createdDate)
        user.urls = self.urls.map { localUrl in
            return RBUrl(urlId: localUrl.urlId, isPrimary: localUrl.isPrimary, createdDate: localUrl.createdDate, url: localUrl.url, state: localUrl.isShown, lastModified: localUrl.lastModified, pageData: localUrl.pageData, viewedLastModified: localUrl.createdDate, urlStatusId: localUrl.urlStatusId)
        }
        return user
    }
}

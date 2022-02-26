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

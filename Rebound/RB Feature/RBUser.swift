//
//  RBUser.swift
//  Rebound
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation

struct RBUser {
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

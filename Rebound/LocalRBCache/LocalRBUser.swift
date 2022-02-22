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

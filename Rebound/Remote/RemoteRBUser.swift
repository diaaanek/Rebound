//
//  File.swift
//  Rebound
//
//  Created by Ethan Keiser on 3/29/22.
//

import Foundation

public struct RemoteRBUser : Codable{
    public let userId : String
    public let userName : String
    public let createdDate : Date
    public var urls : [RemoteRBUrl]
    public init(userId: String, userName: String, createdDate: Date) {
        self.userId = userId
        self.userName = userName
        self.createdDate = createdDate
        self.urls = [RemoteRBUrl]()
    }
}



//
//  RemoteRBUrl.swift
//  Rebound
//
//  Created by Ethan Keiser on 3/29/22.
//

import Foundation

public struct RemoteRBUrl: Codable {
    public let isPrimary: Bool
    public  let createdDate: Date
    public  let lastModified: Date
    public  let viewedLastModified: Date?
    public  let url : String
    public let isShown: Bool
    public let urlStatusId: Int

  
    public init(urlStatusId: Int, isPrimary: Bool, createdDate: Date, url: String, state: Bool, lastModified: Date, viewedLastModified: Date?){
        self.urlStatusId = urlStatusId
        self.isPrimary = isPrimary
        self.createdDate = createdDate
        self.url = url
        self.isShown = state
        self.lastModified = lastModified
        self.viewedLastModified = viewedLastModified
        
    }
}

//
//  RemoteRBUrl.swift
//  Rebound
//
//  Created by Ethan Keiser on 3/29/22.
//

import Foundation

public struct RemoteRBUrl: Codable {
    public let urlId : String
    public let isPrimary: Bool
    public  let createdDate: Date
    public  let lastModified: Date
    public  let viewedLastModified: Date?
    public  let url : String
    public let isShown: Bool
    public let pageData: Data
  
    public init(urlId: String, isPrimary: Bool, createdDate: Date, url: String, state: Bool, lastModified: Date, pageData: Data, viewedLastModified: Date?){
        self.urlId = urlId
        self.isPrimary = isPrimary
        self.createdDate = createdDate
        self.url = url
        self.isShown = state
        self.lastModified = lastModified
        self.viewedLastModified = viewedLastModified
        self.pageData = pageData
        
    }
}

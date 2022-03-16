//
//  RBUrl.swift
//  Rebound
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation

public struct RBUrl: Hashable {
    public let urlId : String
    public let isPrimary: Bool
    public  let createdDate: Date
    public  let lastModified: Date
    public  let viewedLastModified: Date?
    public  let url : String
    public let state: Bool
    
    public init(urlId: String, isPrimary: Bool, createdDate: Date, url: String, state: Bool, lastModified: Date, viewedLastModified: Date?){
        self.urlId = urlId
        self.isPrimary = isPrimary
        self.createdDate = createdDate
        self.url = url
        self.state = state
        self.lastModified = lastModified
        self.viewedLastModified = viewedLastModified
    }
    
    
}

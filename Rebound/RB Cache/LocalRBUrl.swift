//
//  LocalRBUrl.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/20/22.
//

import Foundation

public struct LocalRBUrl {
    public let urlId : String
    public let isPrimary: Bool
    public  let createdDate: Date
    public  let viewedLastModified: Date?
    public  let lastModified: Date
    public  let url : String
    public let isShown: Bool
    public let pageData: Data
    public init(urlId: String, isPrimary: Bool, createdDate: Date, url: String, state: Bool, pageData: Data, viewedLastModified: Date?, lastModified: Date){
        self.urlId = urlId
        self.isPrimary = isPrimary
        self.createdDate = createdDate
        self.url = url
        self.isShown = state
        self.viewedLastModified = viewedLastModified
        self.lastModified = lastModified
        self.pageData = pageData
    }
}

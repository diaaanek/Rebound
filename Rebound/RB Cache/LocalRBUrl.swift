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
    public  let url : String
    public let state: Int
    public init(urlId: String, isPrimary: Bool, createdDate: Date, url: String, state: Int){
        self.urlId = urlId
        self.isPrimary = isPrimary
        self.createdDate = createdDate
        self.url = url
        self.state = state        
    }
}
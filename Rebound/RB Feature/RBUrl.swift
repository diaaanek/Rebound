//
//  RBUrl.swift
//  Rebound
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation

struct RBUrl {
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

//
//  DeleteUrlStatus.swift
//  Rebound
//
//  Created by Ethan Keiser on 4/7/22.
//

import Foundation

public class DeleteUrlStatus {
    let url = "https://444xmwygee.execute-api.us-east-1.amazonaws.com/Production/urlstatus"
    let httpClient : HttpClient
    
    public init(httpClient :HttpClient) {
        self.httpClient = httpClient
    }
    public func deleteUrlStatus(urlStatusId: String, completion: (Result<Void, Error>) -> Void) {
        completion( Result {
            httpClient.delete(urlString: url+"?urlstatus_id=\(urlStatusId)") { result in
            }
        })
    }
}

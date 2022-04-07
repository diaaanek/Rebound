//
//  PostAuthorization.swift
//  Rebound
//
//  Created by Ethan Keiser on 4/6/22.
//

import Foundation

public protocol CreateAuthorization {
    func createAuthorization(igId: String,header: String, completion:(Result<Void,Error>)->Void)
}


public class PostAuthorization:CreateAuthorization {
    let url = "https://444xmwygee.execute-api.us-east-1.amazonaws.com/Production/authorization"
    let httpClient : HttpClient
    private struct PostModel: Codable {
        let ig_id : String
        let header: String
    }
    public init(httpClient :HttpClient) {
        self.httpClient = httpClient
    }
    public func createAuthorization(igId: String,header: String, completion:(Result<Void,Error>)->Void) {
        var encoder = JSONEncoder()
        let body = try! encoder.encode(PostModel(ig_id: igId, header: header))
        completion( Result {
            self.httpClient.post(urlString: url, body: body) { result in
            }
        }
        )
    }
}

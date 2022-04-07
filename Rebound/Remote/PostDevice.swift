//
//  PostDevice.swift
//  Rebound
//
//  Created by Ethan Keiser on 4/6/22.
//

import Foundation


public class PostDevice {
    let url = "https://444xmwygee.execute-api.us-east-1.amazonaws.com/Production/device"
    let httpClient : HttpClient
    private struct PostModel: Codable {
        let ig_id : String
        let type : String
        let identifier: String
    }
    public init(httpClient :HttpClient) {
        self.httpClient = httpClient
    }
    public func createAccount(igId: String, identifier:String, completion: (Result<Void, Error>) -> Void) {
        let encoder = JSONEncoder()
        let body = try! encoder.encode(PostModel(ig_id: igId, type: "ios", identifier: identifier))
        completion( Result {
            self.httpClient.post(urlString: url, body: body) { result in
            }
        }
        )
    }
}


//
//  PostAccount.swift
//  Rebound
//
//  Created by Ethan Keiser on 4/6/22.
//

import Foundation

public protocol CreateAccount {
    func createAccount(igId: String, completion:(Result<Void,Error>)->Void)
}


public class PostAccount:CreateAccount {
    let url = "https://444xmwygee.execute-api.us-east-1.amazonaws.com/Production/account"
    let httpClient : HttpClient
    private struct PostAccountModel: Codable {
        let ig_id : String
    }
    public init(httpClient :HttpClient) {
        self.httpClient = httpClient
    }
    public func createAccount(igId: String, completion: (Result<Void, Error>) -> Void) {
        let encoder = JSONEncoder()
        let body = try! encoder.encode(PostAccountModel(ig_id: igId))
        completion( Result {
            self.httpClient.post(urlString: url, body: body) { result in
            }
        }
        )
    }
}


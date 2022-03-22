//
//  WebUrlLoader.swift
//  Rebound
//
//  Created by Ethan Keiser on 3/16/22.
//

import Foundation

public protocol WebUrlLoader {
    func loadWebUrl(urlString: String, completion: @escaping (Result<(Data, HTTPURLResponse),Error>) -> Void) -> URLSessionDataTask
}

public class RemoteWebUrlLoader : WebUrlLoader {

    let httpClient : HttpClient
    public init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    public func loadWebUrl(urlString: String, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> URLSessionDataTask {
      return self.httpClient.getResult(urlString: urlString) { result in
            switch result {
            case .success((let data, let urlResponse)):
                completion(.success((data, urlResponse)))
               
            case.failure(let error):
                // error handle
                fatalError(error.localizedDescription)
            }
        }
    }
    
}

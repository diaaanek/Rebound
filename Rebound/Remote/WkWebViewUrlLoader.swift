//
//  WkWebViewUrlLoader.swift
//  Rebound
//
//  Created by Ethan Keiser on 3/16/22.
//

import Foundation
public enum UrlError: Error {
    case invalidUrl
}

public class WkWebViewUrlLoader:NSObject, HttpClient {
    var completion : ((Result<(Data,HTTPURLResponse), Error>) -> Void)?
    var headers : [String:String]
    public init(headers: [String:String]) {
        self.headers = headers
    } 
    public func getResult(urlString: String, completion: @escaping (Result<(Data,HTTPURLResponse), Error>) -> Void) -> URLSessionDataTask {
           // UIApplication.shared.connectedScenes.first!.
        guard let url = URL(string:urlString) else {
            completion(.failure(UrlError.invalidUrl))
            fatalError("Invalid Url")
        }
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = headers
            let task = URLSession.shared.dataTask(with:request) { data, urlresponse, error in
                if let data = data, let httpResponse = urlresponse as? HTTPURLResponse {
                    completion(.success((data, httpResponse)))
                }
            }
        task.resume()
        return task
    }
}

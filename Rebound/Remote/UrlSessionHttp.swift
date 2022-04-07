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

public class UrlSessionHttpClient:NSObject, HttpClient {
    var completion : ((Result<(Data,HTTPURLResponse), Error>) -> Void)?
    var headers : [String:String]
    public init(headers: [String:String] = [String:String]()) {
        self.headers = headers
        print(self.headers)
    }
    public func post(urlString:String, body: Data?, completion: @escaping (Result<(Data,HTTPURLResponse), Error>) -> Void) -> URLSessionDataTask {
        guard let url = URL(string:urlString) else {
            completion(.failure(UrlError.invalidUrl))
            fatalError("Invalid Url")
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "Post"
        request.httpBody = body
        let task = URLSession.shared.dataTask(with:request) { data, urlresponse, error in
            if let data = data, let httpResponse = urlresponse as? HTTPURLResponse {
                completion(.success((data, httpResponse)))
            }
        }
        task.resume()
        return task
    }
    public func delete(urlString: String, completion: @escaping (Result<(Data,HTTPURLResponse), Error>) -> Void) -> URLSessionDataTask {
        // UIApplication.shared.connectedScenes.first!.
        guard let url = URL(string:urlString) else {
            completion(.failure(UrlError.invalidUrl))
            fatalError("Invalid Url")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "Delete"
        let task = URLSession.shared.dataTask(with:request) { data, urlresponse, error in
            if let data = data, let httpResponse = urlresponse as? HTTPURLResponse {
                completion(.success((data, httpResponse)))
            }
        }
        task.resume()
        return task
    }
    public func get(urlString: String, completion: @escaping (Result<(Data,HTTPURLResponse), Error>) -> Void) -> URLSessionDataTask {
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

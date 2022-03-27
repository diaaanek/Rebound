//
//  WebUrlLoader.swift
//  Rebound
//
//  Created by Ethan Keiser on 3/16/22.
//

import Foundation
public protocol AsyncTask {
    func cancel()
}

public protocol Loader {
    func load(urlString: String, completion: @escaping (Result<(Data?),Error>) -> Void) -> AsyncTask?
}

public protocol WebUrlLoader {
    func loadWebUrl(urlString: String, completion: @escaping (Result<(Data, HTTPURLResponse),Error>) -> Void) -> URLSessionDataTask
}
public protocol CacheStore {
    func insert(data: Data, key: String)
    func retrieve(key: String) -> Data?
}

public class LoadPrimaryWithFallbackAndCache: Loader {
    let primary : Loader
    let secondary: Loader
    let cache: CacheStore?
    init(primary: Loader,fallback secondary:Loader,cacheTo cache: CacheStore?) {
        self.primary = primary
        self.secondary = secondary
        self.cache = cache
    }
    public func load(urlString: String, completion: @escaping (Result<(Data?), Error>) -> Void) -> AsyncTask? {
        self.primary.load(urlString: urlString) { result in
            
        }
        return nil
    }
}

public class CacheUrlLoader : Loader {
    let store : CacheStore
    public init(store : CacheStore) {
        self.store = store
    }
    public func load(urlString: String, completion: @escaping (Result<(Data?), Error>) -> Void) -> AsyncTask? {
        completion(.success(self.store.retrieve(key: urlString)))
        return nil
    }
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

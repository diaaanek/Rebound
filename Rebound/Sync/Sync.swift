//
//  Sync.swift
//  Rebound
//
//  Created by Ethan Keiser on 3/16/22.
//

import Foundation

public class Sync  {
    let webLoader: WebUrlLoader
    let rbUserStore: RBUserStore
    let rbUrlStore : RBUrlStore
    public init(webLoader:WebUrlLoader, rbUserStore: RBUserStore, rbUrlStore: RBUrlStore) {
        self.webLoader = webLoader
        self.rbUserStore = rbUserStore
        self.rbUrlStore = rbUrlStore
    }
    public func syncAll(completion: @escaping ()->()){
        rbUserStore.retrieve { result in
            switch result {
            case .success(let localUsers):
                let dispatchGroup = DispatchGroup()
                if let localUsers = localUsers {
                    for user in localUsers {
                        user.urls.map({ local in
                            return RBUrl(urlId: local.urlId, isPrimary: local.isPrimary, createdDate: local.createdDate, url: local.url, state: local.state, lastModified: local.lastModified, viewedLastModified: local.viewedLastModified)
                        }).forEach { url in
                            
                            dispatchGroup.enter()
                            _ = self.sync(rbUrl: url) { syncedUrl in
                              switch syncedUrl {
                              case .success(let rbUrl):
                                  // merge
                                  self.rbUrlStore.merge(rbUrl: LocalRBUrl(urlId: rbUrl.urlId, isPrimary: rbUrl.isPrimary, createdDate: rbUrl.createdDate, url: rbUrl.url, state: rbUrl.state, viewedLastModified: rbUrl.viewedLastModified, lastModified: rbUrl.lastModified)) { result in
                                      dispatchGroup.leave()
                                  }
                                  print(rbUrl.url)
                              case .failure(let error):
                                  print(error.localizedDescription)
                                  dispatchGroup.leave()
                              }
                            
                            }
                        }
                    }
                    dispatchGroup.notify(queue: .main) {
                       completion()
                    }
                }
                break
            case .failure(let error):
                fatalError(error.localizedDescription)
                break
            }
        }
    }
    
    @discardableResult
    public func sync(rbUrl: RBUrl, completion: @escaping (Result<RBUrl, Error>)->Void) -> URLSessionDataTask {
        
       let task = self.webLoader.loadWebUrl(urlString: rbUrl.url) { result in
            switch result {
            case .success((_, let httpUrlResponse)):
                let isShown = httpUrlResponse.statusCode == 200
                if rbUrl.state != isShown {
                    let today = Date()
                    completion(.success(RBUrl(urlId: rbUrl.urlId, isPrimary: rbUrl.isPrimary, createdDate: rbUrl.createdDate, url: rbUrl.url, state: isShown, lastModified: today, viewedLastModified: today)))
                } else {
                    completion(.success(rbUrl))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}

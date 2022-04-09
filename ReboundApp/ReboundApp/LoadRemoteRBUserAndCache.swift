//
//  LoadRemoteRBUserAndCache.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 4/7/22.
//

import Foundation
import Rebound
class LoadRemoteUserAndCache {
    let cacheUrlStore : RBUrlStore
    let remoteStore : GetUrls
    init(urlStore: RBUrlStore, remote: GetUrls) {
        self.cacheUrlStore = urlStore
        self.remoteStore = remote
    }
    
    public func getUrls(ig_id: String, completion: @escaping () -> Void) {
        self.remoteStore.getUrls(ig_id: ig_id) { [ weak self] result in
            guard let self = self else {
                completion()
                return
            }
            let dispatchGroup = DispatchGroup()
            
            switch result {
            case .success(let users):
                for remoteUser in users {
                   var user = LocalRBUser(userId: "", userName: remoteUser.userName, createdDate: remoteUser.createdDate)
                    user.urls = remoteUser.urls.map({ remoteUrl in
                        return LocalRBUrl(urlId: "", isPrimary: true, createdDate: remoteUrl.createdDate, url: remoteUrl.url, state: remoteUrl.isShown, viewedLastModified: remoteUrl.viewedLastModified, lastModified: remoteUrl.lastModified, urlStatusId: remoteUrl.urlStatusId)
                    })
                    dispatchGroup.enter()
                    self.cacheUrlStore.insert(rbUrl: user.urls, user: user, timestamp: Date()) { result in
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    completion()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

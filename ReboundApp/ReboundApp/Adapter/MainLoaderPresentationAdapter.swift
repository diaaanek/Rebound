//
//  MainLoaderPresentationAdapter.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 2/23/22.
//

import Foundation
import ReboundiOS
import Rebound

class MainLoaderPresentationAdapter: MainViewDelegate {
    let loader : RBUserStore
    public var presenter : MainFeedPresenter?
    init(cache: RBUserStore) {
        self.loader = cache
    }
    
    func didRefreshData() {
        presenter!.didStartLoading()
        loader.retrieve {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(.some(let users)):
                    self?.presenter?.didDisplay(rbUser:  users.map { localUser in
                        var user = RBUser(userId: localUser.userId,
                                      userName: localUser.userName, createdDate: localUser.createdDate)
                        
                        user.urls = localUser.urls.map { localUrl in
                           return RBUrl(urlId: localUrl.urlId, isPrimary: localUrl.isPrimary, createdDate: localUrl.createdDate, url: localUrl.url, state: localUrl.state)
                        }
                        return user
                    })
                case .failure(let error):
                    self?.presenter?.didFinishLoading(error: error)
                case .success(.none):
                    self?.presenter?.didDisplay(rbUser:[RBUser]())
                }
            }
        }
    }
}

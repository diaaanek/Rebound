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
        DispatchQueue.main.async {
            self.presenter!.didStartLoading()
        }
        loader.retrieve {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(.some(let users)):
                    self?.presenter?.didDisplay(rbUser:  users.map { localUser in
                        return localUser.getRBUser()
                    })
                case .failure(let error):
                    DispatchQueue.main.async {
                    self?.presenter?.didFinishLoading(error: error)
                    }
                case .success(.none):
                    DispatchQueue.main.async {
                    self?.presenter?.didDisplay(rbUser:[RBUser]())
                    }
                }
            }
        }
    }
}

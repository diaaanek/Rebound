//
//  MainFeedComposer.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 2/23/22.
//

import Foundation
import ReboundiOS
import Rebound
import UIKit
import CoreData
import Swiftagram
class MainFeedComposer {
    
    func makeMainFeedController(cache: CoreDataStore, mainNavigationFlow: MainNavigationFlow) -> MainViewController {
        let bundle = Bundle(for: MainViewController.self)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        mainViewController.cellSelected = { user in
            mainNavigationFlow.navigateToCreate(rbUser: user)
        }
        mainViewController.navigateCreate = {
            mainNavigationFlow.navigateToCreate()
        }

       // mainViewController.navigationItem.searchController = searchBarController
        mainViewController.navigationItem.hidesSearchBarWhenScrolling = true
        let loaderAdapter = MainLoaderPresentationAdapter(cache:cache)
        mainViewController.delegate = loaderAdapter
        
        let adapter = MainPresenationAdapter(lastOpenedDate: Date(), mainNavigation: mainNavigationFlow)
        let mainFeedPresenter = MainFeedPresenter(loadingView: WeakVirtualProxy(mainViewController), errorView: WeakVirtualProxy(mainViewController), mainView: adapter)
        adapter.controller = mainViewController
        loaderAdapter.presenter = mainFeedPresenter
        mainViewController.sectionHeader1 = MainFeedPresenter.updatesSectionTitle
        mainViewController.sectionHeader2 = MainFeedPresenter.noSectionTitle
        mainViewController.didRequestSync = {
            let secret = try! Secret.decoding(UserDefaults.standard.data(forKey: "secret")!)
            let sync = Sync(webLoader: RemoteWebUrlLoader(httpClient:WkWebViewUrlLoader(headers: secret.header)), rbUserStore: cache, rbUrlStore: cache)
          //  mainFeedPresenter.didStartLoading()
            sync.syncAll {
                mainViewController.reloadCollectionView()

            }
        }
        mainViewController.navigateAccount = {
            
            mainNavigationFlow.navigateToAccount()
        }
        return mainViewController
    }
    

}

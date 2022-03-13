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
class MainFeedComposer {
    
    func makeMainFeedController(cache: CoreDataStore, mainNavigationFlow: MainNavigationFlow) -> MainViewController {
        let bundle = Bundle(for: MainViewController.self)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        mainViewController.cellSelected = { user in
            mainNavigationFlow.navigateToCreate(rbUser: user)
        }
        mainViewController.navigateCreate = {
            mainNavigationFlow.navigateToCreate(rbUser: nil)
        }
        let searchDisplayController = SearchResultController()
        let searchBarController = SearchController(searchDisplayController, resultUpdate: searchDisplayController)
        searchBarController.searchBar.placeholder = "Username"
       // mainViewController.navigationItem.searchController = searchBarController
        mainViewController.navigationItem.hidesSearchBarWhenScrolling = true
    
        let loaderAdapter =  MainLoaderPresentationAdapter(cache:cache)
        mainViewController.delegate = loaderAdapter
        
        let adapter = MainPresenationAdapter(lastOpenedDate: Date(), mainNavigation: mainNavigationFlow)
        let mainFeedPresenter = MainFeedPresenter(loadingView: WeakVirtualProxy(mainViewController), errorView: WeakVirtualProxy(mainViewController), mainView: adapter)
        adapter.controller = mainViewController
        loaderAdapter.presenter = mainFeedPresenter
        mainViewController.sectionHeader1 = MainFeedPresenter.updatesSectionTitle
        mainViewController.sectionHeader2 = MainFeedPresenter.noSectionTitle
    
        return mainViewController
    }

}

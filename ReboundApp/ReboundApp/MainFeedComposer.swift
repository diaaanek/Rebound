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
    
    func makeMainFeedController() -> MainViewController {
        let bundle = Bundle(for: MainViewController.self)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        var path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        path = path.appendingPathComponent("test.sqlite")
        let cache = try! CoreDataStore(storeURL: path)
        
        let list = [LocalRBUrl(urlId:"2", isPrimary: true, createdDate: Date(), url: "https://www.instagram.com/p/CaFbcwbl0Oz/?utm_source=ig_web_copy_link", state: 0),LocalRBUrl(urlId:"2", isPrimary: true, createdDate: Date(), url: "https://www.instagram.com/p/CaFbcwbl0Oz/?utm_source=ig_web_copy_link", state: 0),LocalRBUrl(urlId:"2", isPrimary: true, createdDate: Date(), url: "https://www.instagram.com/itsEthanKeiser/", state: 0),LocalRBUrl(urlId:"2", isPrimary: true, createdDate: Date(), url: "https://www.instagram.com/p/CaFbcwbl0Oz/?utm_source=ig_web_copy_link", state: 0),LocalRBUrl(urlId:"2", isPrimary: true, createdDate: Date(), url: "https://www.instagram.com/p/CaFbcwbl0Oz/?utm_source=ig_web_copy_link", state: 0)]
        var user = LocalRBUser(userId:"2", userName: "diannnek", createdDate: Date())
        user.urls = list
        cache.insert(rbUrl: list, user: user, timestamp: Date()) { result in

        }
        let loaderAdapter =  MainLoaderPresentationAdapter(cache:cache)
        mainViewController.delegate = loaderAdapter
        
        let adapter = MainPresenationAdapter(lastOpenedDate: Date())
        let mainFeedPresenter = MainFeedPresenter(loadingView: WeakVirtualProxy(mainViewController), errorView: WeakVirtualProxy(mainViewController), mainView: adapter)
        adapter.controller = mainViewController
        loaderAdapter.presenter = mainFeedPresenter
        mainViewController.sectionHeader1 = MainFeedPresenter.updatesSectionTitle
        mainViewController.sectionHeader2 = MainFeedPresenter.noSectionTitle
        
        return mainViewController
    }
}

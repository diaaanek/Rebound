//
//  CreateComposer.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/11/22.
//

import Foundation
import ReboundiOS
import UIKit
import Rebound

class CreateComposer {
    
    func composeCreateViewController(rbUser: RBUser?, coreDataStore: CoreDataStore, navigationController: UINavigationController, refreshData: (()->())?)  -> EditRBUserController {
        let bundle = Bundle(for: MainViewController.self)
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)

        let editRBUserController = storyBoard.instantiateViewController(withIdentifier: "EditRBUserController") as! EditRBUserController
        editRBUserController.rbUser = rbUser
        let adapter = EditUserDataStoreAdapter(rbUserStore: coreDataStore, rbUrlStore: coreDataStore, editNav: EditControllerNavigation(navigationController: navigationController))
        
        var itemControllers = [EditItemController]()
        if let rb = rbUser {
            itemControllers.append(EditItemController(topLabelText: "Name", url: nil, placeHolder: "username", displayText: rb.userName, delegate: nil))
            itemControllers.append(contentsOf:rb.urls.map { rbUrl in
              let presenter = EditPresenter()
              let editItem = EditItemController(topLabelText: "Photo Url", url: URL(string: rbUrl.url), placeHolder: "Copy Instagram photo url", displayText: rbUrl.url, delegate: EditValidationPresenterAdapter(presenter: presenter))
                presenter.editView = WeakVirtualProxy(editItem)
                return editItem
            })
        } else {
            itemControllers.append(EditItemController(topLabelText: "Name", url: nil, placeHolder: "username", delegate: nil))
            for _ in 0..<4 {
                let presenter = EditPresenter()
                let editItem = EditItemController(topLabelText: "Photo Url", url: nil, placeHolder: "Copy Instagram photo url", delegate: EditValidationPresenterAdapter(presenter: presenter))
                  presenter.editView = WeakVirtualProxy(editItem)
                itemControllers.append(editItem)
            }
        }
        editRBUserController.modelViews = itemControllers
        
        adapter.refreshData = refreshData
        editRBUserController.delegate = adapter
        editRBUserController.validateUrl = { stringUrl in
            return true
        }
        return editRBUserController
    }
}

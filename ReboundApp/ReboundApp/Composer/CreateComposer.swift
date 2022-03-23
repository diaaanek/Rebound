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
        var presenters = [EditPresenter]()
        let bundle = Bundle(for: MainViewController.self)
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)

        let editRBUserController = storyBoard.instantiateViewController(withIdentifier: "EditRBUserController") as! EditRBUserController
        editRBUserController.rbUser = rbUser
        
        var itemControllers = [EditItemController]()
        if let rb = rbUser {
            let nameEditItem = EditItemController(topLabelText: "Target's Instagram Username", url: nil, placeHolder: "username", displayText: rb.userName, delegate: nil)
            nameEditItem.refresh = {
                editRBUserController.tableView.reloadData()
            }
            itemControllers.append(nameEditItem)
            let nameEditPresenter = EditPresenter()
            nameEditPresenter.editView = nameEditItem
            presenters.append(nameEditPresenter)
            var count = 1
            itemControllers.append(contentsOf:rb.urls.map { rbUrl in
                let presenter = EditPresenter()
                presenters.append(presenter)
                let editItem = EditItemController(topLabelText: "Photo Url \(count):", url: URL(string: rbUrl.url), placeHolder: "Copy Instagram photo url", displayText: rbUrl.url, delegate: EditValidationPresenterAdapter(presenter: presenter))
                presenter.editView = WeakVirtualProxy(editItem)
                editItem.refresh = {
                    editRBUserController.tableView.reloadData()
                }
                count += 1
                return editItem
            })
        } else {
            let nameEditItem = EditItemController(topLabelText: "Target's Instagram Username", url: nil, placeHolder: "username", delegate: nil)
            itemControllers.append(nameEditItem)
            let nameEditPresenter = EditPresenter()
            nameEditPresenter.editView = nameEditItem
            nameEditItem.refresh = {
                editRBUserController.tableView.reloadData()
            }
            presenters.append(nameEditPresenter)
            for i in 0..<4 {
                let presenter = EditPresenter()
                presenters.append(presenter)
                let controller = EditItemController(topLabelText: "Photo Url \(i+1):", url: nil, placeHolder: "Copy Instagram photo url", delegate: EditValidationPresenterAdapter(presenter: presenter))
                let editItem = controller
                  presenter.editView = WeakVirtualProxy(editItem)
                editItem.refresh = {
                    editRBUserController.tableView.reloadData()
                }
                itemControllers.append(editItem)
                
            }
        }
        let adapter = EditUserDataStoreAdapter(rbUserStore: coreDataStore, rbUrlStore: coreDataStore, editNav: EditControllerNavigation(navigationController: navigationController), presenters: presenters)
        editRBUserController.delegate = adapter
        editRBUserController.modelViews = itemControllers
        adapter.refreshData = refreshData
        editRBUserController.validateUrl = { stringUrl in
            return true
        }
        return editRBUserController
    }
}

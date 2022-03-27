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
    
    func composeCreateViewController(rbUser: RBUser, coreDataStore: CoreDataStore, navigationController: UINavigationController, refreshData: (()->())?)  -> EditRBUserController {
        var presenters = [EditPresenter]()
        let bundle = Bundle(for: MainViewController.self)
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)
        
        let editRBUserController = storyBoard.instantiateViewController(withIdentifier: "EditRBUserController") as! EditRBUserController
        editRBUserController.rbUser = rbUser
        
        var itemControllers = [EditItemController]()
        let nameEditItem = EditItemController(topLabelText: "Target's Instagram Username", url: nil, placeHolder: "username", displayText: rbUser.userName, delegate: nil)
        nameEditItem.refresh = {
            editRBUserController.tableView.reloadData()
        }
        itemControllers.append(nameEditItem)
        let nameEditPresenter = EditPresenter()
        nameEditPresenter.editView = nameEditItem
        presenters.append(nameEditPresenter)
        var count = 1
        itemControllers.append(contentsOf:rbUser.urls.map { rbUrl in
            let presenter = EditPresenter()
            presenters.append(presenter)
            let editItem = EditItemController(topLabelText: "Photo Url \(count):", url: URL(string: rbUrl.url), placeHolder: "Copy Instagram photo url", displayText: rbUrl.url, delegate: EditUrlValidationPresenterAdapter(presenter: presenter))
            presenter.editView = WeakVirtualProxy(editItem)
            editItem.refresh = {
                editRBUserController.tableView.reloadData()
            }
            count += 1
            return editItem
        })
        
        let adapter = EditUserDataStoreAdapter(rbUserStore: coreDataStore, rbUrlStore: coreDataStore, editNav: EditControllerNavigation(navigationController: navigationController))
        editRBUserController.delegate = adapter
        editRBUserController.editItems = itemControllers
        adapter.refreshData = refreshData
        
        return editRBUserController
    }
    func composeCreateViewController(nameString: String, urlString: String, coreDataStore: CoreDataStore, navigationController: UINavigationController, refreshData: (()->())?)  -> EditRBUserController {
        let bundle = Bundle(for: MainViewController.self)
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)
        var itemControllers = [EditItemController]()

        let editRBUserController = storyBoard.instantiateViewController(withIdentifier: "EditRBUserController") as! EditRBUserController
        let refresh = {
            editRBUserController.tableView.reloadData()
        }
        
        let nameEditPresenter = EditPresenter()
        let nameItemController = createEditItemController(topLabel: "Target's Instagram Username", placeholder: "username", displayText: nameString, validationDelegate: EditUserNameValidationPresenterAdapter(presenter: nameEditPresenter), presenter: nameEditPresenter, refreshItem: refresh)
        
        let urlEditPresenter = EditPresenter()
        let urlItemController = createEditItemController(topLabel: "Target's Instagram Url:", placeholder: "Copy Instagram photo url", displayText: urlString, validationDelegate: EditUrlValidationPresenterAdapter(presenter: urlEditPresenter), presenter: urlEditPresenter, refreshItem: refresh)
        
        itemControllers.append(nameItemController)
        itemControllers.append(urlItemController)
        
        for i in 2..<4 {
            let presenter = EditPresenter()
            
            let optionUrlItemControllers = createEditItemController(topLabel: "Optional: Photo Url:", placeholder: "Paste link to relationship photo here...", displayText: "", validationDelegate:  EditOptionalUrlValidationPresenterAdapter(presenter: presenter), presenter: presenter, refreshItem: refresh)
            itemControllers.append(optionUrlItemControllers)
        }
        
        let adapter = EditUserDataStoreAdapter(rbUserStore: coreDataStore, rbUrlStore: coreDataStore, editNav: EditControllerNavigation(navigationController: navigationController))
        editRBUserController.delegate = adapter
        editRBUserController.editItems = itemControllers
        adapter.refreshData = refreshData
        return editRBUserController
    }
    private func createEditItemController(topLabel: String, placeholder: String, displayText: String, validationDelegate: EditItemControllerDelegate?, presenter: EditPresenter, refreshItem: @escaping ()->()) -> EditItemController {
        let editItemController = EditItemController(topLabelText: topLabel, url: nil, placeHolder: placeholder, displayText: displayText, delegate: validationDelegate)
        editItemController.refresh = refreshItem
        presenter.editView = editItemController

        
        return editItemController
    }
}

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

class CreateEditRbUserComposer {
    
    func composeEditRBUserViewController(rbUser: RBUser, coreDataStore: CoreDataStore, navigationController: UINavigationController, refreshData: (()->())?)  -> EditRBUserController {
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
        nameEditItem.wknavigationDelegate = WkNavigationDelegateComposite(list: [GetStatusWkNavigationDelegate(completion:{ isShown, pageData in
            nameEditItem.pageData = pageData
            nameEditItem.isShownOnProfile = isShown
        }),RemoveHeadersWkNavigationDelegate()])
        itemControllers.append(nameEditItem)
        let nameEditPresenter = EditPresenter()
        nameEditPresenter.editView = nameEditItem
        presenters.append(nameEditPresenter)
        itemControllers.append(contentsOf:rbUser.urls.map { rbUrl in
            let presenter = EditPresenter()
            presenters.append(presenter)
            let editItem = EditItemController(topLabelText: "Target's Instagram Url:", url: URL(string: rbUrl.url), placeHolder: "Paste link to relationship photo or video here...", displayText: rbUrl.url, delegate: EditUrlValidationPresenterAdapter(presenter: presenter))
            presenter.editView = WeakVirtualProxy(editItem)
            editItem.wknavigationDelegate = WkNavigationDelegateComposite(list: [GetStatusWkNavigationDelegate(completion:{ isShown, pageData in
                nameEditItem.pageData = pageData
                nameEditItem.isShownOnProfile = isShown
            }),RemoveHeadersWkNavigationDelegate()])
            editItem.refresh = {
                editRBUserController.tableView.reloadData()
            }
            return editItem
        })
        
        let adapter = EditUserDataStoreAdapter(userId: rbUser.userId, rbUserStore: coreDataStore, rbUrlStore: coreDataStore, editNav: EditControllerNavigation(navigationController: navigationController))
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
        let nameItemController = createEditItemController(topLabel: "Target's Instagram Username", placeholder: "username", displayText: nameString, validationDelegate: EditUserNameValidationPresenterAdapter(presenter: nameEditPresenter), presenter: nameEditPresenter, url: nil, refreshItem: refresh)
        
        let urlEditPresenter = EditPresenter()
        let urlItemController = createEditItemController(topLabel: "Target's Instagram Url:", placeholder: "Paste link to relationship photo or video here...", displayText: urlString, validationDelegate: EditUrlValidationPresenterAdapter(presenter: urlEditPresenter), presenter: urlEditPresenter, url: URL(string:urlString), refreshItem: refresh)
        
        itemControllers.append(nameItemController)
        itemControllers.append(urlItemController)
        
        for _ in 2..<4 {
            let presenter = EditPresenter()
            
            let optionUrlItemControllers = createEditItemController(topLabel: "Optional Target's Instagram Url:", placeholder: "Paste link to relationship photo or video here...", displayText: "", validationDelegate:  EditOptionalUrlValidationPresenterAdapter(presenter: presenter), presenter: presenter, url: nil, refreshItem: refresh)
            itemControllers.append(optionUrlItemControllers)
        }
        
        let adapter = CreateUserDataStoreAdapter(rbUserStore: coreDataStore, rbUrlStore: coreDataStore, editNav: EditControllerNavigation(navigationController: navigationController))
        editRBUserController.delegate = adapter
        editRBUserController.editItems = itemControllers
        adapter.refreshData = refreshData
        return editRBUserController
    }
    private func createEditItemController(topLabel: String, placeholder: String, displayText: String, validationDelegate: EditItemControllerDelegate?, presenter: EditPresenter, url: URL?,  refreshItem: @escaping ()->()) -> EditItemController {
        let editItemController = EditItemController(topLabelText: topLabel, url: url, placeHolder: placeholder, displayText: displayText, delegate: validationDelegate)
        editItemController.refresh = refreshItem
        presenter.editView = editItemController
        editItemController.wknavigationDelegate = WkNavigationDelegateComposite(list: [GetStatusWkNavigationDelegate(completion:{ isShown, pageData in
            editItemController.pageData = pageData
            editItemController.isShownOnProfile = isShown
        }),RemoveHeadersWkNavigationDelegate()])

        
        return editItemController
    }
}

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
        
        let refresh = {
            editRBUserController.tableView.reloadData()
        }
        
        var itemControllers = [EditItemController]()
        let nameEditItem = EditItemController(topLabelText: "Target's Instagram Username", url: nil, placeHolder: "username", displayText: rbUser.userName, remoteId: nil, delegate: nil)
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
        let url = rbUser.urls.first!
        let urlEditPresenter = EditPresenter()
        let urlItemController = createEditItemController(remoteId: url.urlStatusId, topLabel: "Target's Instagram Url:", placeholder: "Paste link to relationship photo or video here...", displayText: url.url, validationDelegate: EditUrlValidationPresenterAdapter(presenter: urlEditPresenter), presenter: urlEditPresenter, url: URL(string:url.url), refreshItem: refresh)
        itemControllers.append(urlItemController)
        presenters.append(urlEditPresenter)
        itemControllers.append(contentsOf:rbUser.urls[1...].map { rbUrl in
            
        let presenter = EditPresenter()
            let editItem = createEditItemController(remoteId: rbUrl.urlStatusId, topLabel: "Optional Target's Instagram Url:", placeholder: "Paste link to relationship photo or video here...", displayText: rbUrl.url, validationDelegate:  EditOptionalUrlValidationPresenterAdapter(presenter: presenter), presenter: presenter, url: URL(string:rbUrl.url), refreshItem: refresh)
            presenters.append(presenter)
            return editItem
        })
        var i = itemControllers.count
        while i < 5 {
            let presenter = EditPresenter()
            let optionUrlItemControllers = createEditItemController(remoteId: nil, topLabel: "Optional Target's Instagram Url:", placeholder: "Paste link to relationship photo or video here...", displayText: "", validationDelegate:  EditOptionalUrlValidationPresenterAdapter(presenter: presenter), presenter: presenter, url: nil, refreshItem: refresh)
            itemControllers.append(optionUrlItemControllers)
            i += 1
        }
        
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
        let nameItemController = createEditItemController(remoteId: nil, topLabel: "Target's Instagram Username", placeholder: "username", displayText: nameString, validationDelegate: EditUserNameValidationPresenterAdapter(presenter: nameEditPresenter), presenter: nameEditPresenter, url: nil, refreshItem: refresh)
        
        let urlEditPresenter = EditPresenter()
        let urlItemController = createEditItemController(remoteId: nil, topLabel: "Target's Instagram Url:", placeholder: "Paste link to relationship photo or video here...", displayText: urlString, validationDelegate: EditUrlValidationPresenterAdapter(presenter: urlEditPresenter), presenter: urlEditPresenter, url: URL(string:urlString), refreshItem: refresh)
        
        itemControllers.append(nameItemController)
        itemControllers.append(urlItemController)
        
        for _ in 2..<4 {
            let presenter = EditPresenter()
            let optionUrlItemControllers = createEditItemController(remoteId: nil, topLabel: "Optional Target's Instagram Url:", placeholder: "Paste link to relationship photo or video here...", displayText: "", validationDelegate:  EditOptionalUrlValidationPresenterAdapter(presenter: presenter), presenter: presenter, url: nil, refreshItem: refresh)
            itemControllers.append(optionUrlItemControllers)
        }
        
        let adapter = CreateUserDataStoreAdapter(rbUserStore: coreDataStore, rbUrlStore: coreDataStore, editNav: EditControllerNavigation(navigationController: navigationController))
        editRBUserController.delegate = adapter
        editRBUserController.editItems = itemControllers
        adapter.refreshData = refreshData
        return editRBUserController
    }
    private func createEditItemController(remoteId: Int?, topLabel: String, placeholder: String, displayText: String, validationDelegate: EditItemControllerDelegate?, presenter: EditPresenter, url: URL?,  refreshItem: @escaping ()->()) -> EditItemController {
        let editItemController = EditItemController(topLabelText: topLabel, url: url, placeHolder: placeholder, displayText: displayText, remoteId: remoteId, delegate: validationDelegate)
        editItemController.refresh = refreshItem
        presenter.editView = editItemController
        editItemController.wknavigationDelegate = WkNavigationDelegateComposite(list: [GetStatusWkNavigationDelegate(completion:{ isShown, pageData in
            editItemController.pageData = pageData
            editItemController.isShownOnProfile = isShown
        }),RemoveHeadersWkNavigationDelegate()])

        
        return editItemController
    }
}

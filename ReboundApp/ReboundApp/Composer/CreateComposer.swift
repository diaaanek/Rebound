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
        adapter.refreshData = refreshData
        editRBUserController.delegate = adapter
        editRBUserController.validateUrl = { stringUrl in
            return true
        }
        return editRBUserController
    }
}

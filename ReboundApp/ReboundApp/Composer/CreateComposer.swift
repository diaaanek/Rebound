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
    
    func composeCreateViewController(rbUser: RBUser?, coreDataStore: CoreDataStore, navigationController: UINavigationController)  -> EditRBUserController {
        let bundle = Bundle(for: MainViewController.self)
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)

        let editRBUserController = storyBoard.instantiateViewController(withIdentifier: "EditRBUserController") as! EditRBUserController
        editRBUserController.rbUser = rbUser
        editRBUserController.delegate = EditUserDataStoreAdapter(rbUserStore: coreDataStore, rbUrlStore: coreDataStore, editNav: EditControllerNavigation(navigationController: navigationController))
        editRBUserController.validateUrl = { stringUrl in
            return true
        }
        return editRBUserController
    }
}

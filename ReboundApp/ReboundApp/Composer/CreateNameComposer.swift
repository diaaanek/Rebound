//
//  CreateNameComposer.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/25/22.
//

import Foundation
import UIKit
import Rebound
import ReboundiOS

class CreateNameComposer {
    func composeCreateViewController(coreData: CoreDataStore, navigationController: UINavigationController, refreshData: (()->())?)  -> UIViewController {
        let presenter = EditPresenter()
        let bundle = Bundle(for: MainViewController.self)
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)

        let createNameController = storyBoard.instantiateViewController(withIdentifier: "EditRBUserController") as! EditRBUserController
        let nameValidation = EditUserNameValidationPresenterAdapter(presenter: presenter)
        let nameEditItem = EditItemController(topLabelText: "Target's Instagram Username", url: nil, placeHolder: "username", displayText: "", remoteId: nil, delegate: nameValidation)
            nameEditItem.refresh = {
                createNameController.tableView.reloadData()
            }
        createNameController.editItems.append(nameEditItem)
            presenter.editView = nameEditItem
        createNameController.imageTextItem = ImageTextFieldItemController(imageString: "findig", text: "What is the target's instagram username?")
        createNameController.configDelegate = EditImageTextFieldConfig()
        createNameController.delegate = CreateNameAdapterNavigation(nav: navigationController, coreDate: coreData, refresh: refreshData!)
        return createNameController
    }
}
class EditImageTextFieldConfig: EditConfigDelegate {
    func configButtons(saveButton: UIButton, deleteButton: UIButton) {
        saveButton.setTitle("Next", for: .normal)
        deleteButton.isHidden = true
    }
    
    
}

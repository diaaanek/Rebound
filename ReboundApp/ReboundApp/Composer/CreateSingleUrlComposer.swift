//
//  CreateEmailComposer.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/26/22.
//

import Foundation
import Rebound
import ReboundiOS
import UIKit

class CreateSingleUrlComposer {
    let coreData : CoreDataStore
    public init(coreData: CoreDataStore) {
        self.coreData = coreData
    }
    func composeCreateViewController(nameString: String, navigationController: UINavigationController, refreshData: (()->())?)  -> UIViewController {
        let presenter = EditPresenter()
        let bundle = Bundle(for: MainViewController.self)
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)

        let createNameController = storyBoard.instantiateViewController(withIdentifier: "EditRBUserController") as! EditRBUserController
        let nameValidation = EditUrlValidationPresenterAdapter(presenter: presenter)
            let nameEditItem = EditItemController(topLabelText: "Target's url link", url: nil, placeHolder: "Paste link to relationship photo here...", displayText: "", delegate: nameValidation)
            nameEditItem.refresh = {
                createNameController.tableView.reloadData()
            }
        createNameController.editItems.append(nameEditItem)
            presenter.editView = nameEditItem
        createNameController.imageTextItem = ImageTextFieldItemController(imageString: "copylink", text: "Go to Instagram and copy the link of a relationship image or video. We'll let you know when they delete it. That's a good indicator that the relationship has ended.")
        createNameController.configDelegate = EditImageTextFieldConfig()
        createNameController.delegate = CreateUrlAdapterNavigation(nav: navigationController, nameItem: nameString, coreDataStore: self.coreData, refreshData: refreshData ?? {}) // revisit
        return createNameController
    }
}

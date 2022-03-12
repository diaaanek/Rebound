//
//  EditControllerNavigation.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/12/22.
//

import Foundation
import UIKit

class EditControllerNavigation {
    let navigationController : UINavigationController
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    func navigateToSuccessSave() {
        self.navigationController.dismiss(animated: true, completion: nil)
    }
    func navigateToSuccessDelete() {
        self.navigationController.dismiss(animated: true, completion: nil)
    }
    
}

//
//  EditControllerNavigation.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/12/22.
//

import Foundation
import UIKit
import ReboundiOS

class EditControllerNavigation {
    let navigationController : UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    func navigateToSuccessSave() {
        DispatchQueue.main.async {
            if NotificationPolicy.authorizationStatus == .notDetermined {
                let requestNotificationsVC = ComposeRequestNotificationViewController().makeRequestNotificationVC(navigationController: self.navigationController)
                self.navigationController.setViewControllers([requestNotificationsVC], animated: true)
            } else {
                self.navigationController.dismiss(animated: true, completion: nil)
            }
        }
    }
    func navigateToSuccessDelete() {
        DispatchQueue.main.async {
        self.navigationController.dismiss(animated: true, completion: nil)
        }
    }
    
}

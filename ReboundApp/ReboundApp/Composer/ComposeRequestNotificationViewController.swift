//
//  ComposeRequestNotificationViewController.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/27/22.
//

import Foundation
import UIKit
import ReboundiOS
import UserNotifications

class ComposeRequestNotificationViewController {
    func makeRequestNotificationVC(navigationController: UINavigationController) -> UIViewController {
        let bundle = Bundle(for: MainViewController.self)
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)
        let vc = storyBoard.instantiateViewController(withIdentifier: "RequestNotificationViewController") as! RequestNotificationViewController
        vc.requestNotifications = {
            UNUserNotificationCenter.current()
              .requestAuthorization(
                options: [.alert, .sound, .badge]) { granted, _ in
                    NotificationPolicy.getNotificationSettings { status in
                        if status == .authorized {
                            DispatchQueue.main.async {
                              UIApplication.shared.registerForRemoteNotifications()
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        navigationController.dismiss(animated: true)
                    }
              }
        }
        return vc
        
    }
}

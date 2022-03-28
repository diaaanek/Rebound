//
//  RequestNotificationViewController.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/27/22.
//

import Foundation
import UIKit

public class RequestNotificationViewController: UIViewController {
    public var requestNotifications : (()->())?
    @IBAction func enableNotifications_touchupInside(_ sender: Any) {
        requestNotifications?()
    }
}

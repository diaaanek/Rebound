//
//  AccountNavigation.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/21/22.
//

import Foundation
import UIKit

public class AccountNavigation {
    private let intro : UIViewController
    private let navigation: UINavigationController
    init(intro: UIViewController, navigation: UINavigationController) {
        self.intro = intro
        self.navigation = navigation
    }
    func navigateToIntro() {
        if self.navigation.presentedViewController != nil {
            self.navigation.dismiss(animated: true)
        }
        self.navigation.setViewControllers([intro], animated: true)
    }
}

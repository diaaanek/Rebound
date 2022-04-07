//
//  AccountTableViewComposer.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/21/22.
//

import Foundation
import ReboundiOS
import Rebound
import UIKit
public class AccountTableViewComposer {
    let accountNavigation: AccountNavigation
    let userStore : RBUserStore
    init(accountNavigation: AccountNavigation, coreData: RBUserStore){
        self.userStore = coreData
        self.accountNavigation = accountNavigation
    }
    
    public func makeAccountTableView() -> AccountTableViewController {
        
        let accountViewController = UIStoryboard(name: "Main", bundle: Bundle(for: MainItemController.self)).instantiateViewController(withIdentifier: "AccountTableViewController") as! AccountTableViewController
        accountViewController.logOut = {
            let shared = UserDefaults()
             shared.set(nil, forKey: "secret")
             shared.synchronize()
            self.userStore.deleteRBUser { result in
                
            }
            self.accountNavigation.navigateToIntro()
           
        }
        return accountViewController
    }
}

//
//  IntroComposer.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/17/22.
//

import Foundation
import UIKit
import ReboundiOS
import Swiftagram

public class IntroComposer {
    
    public func makeIntro(navigation:@escaping()->()) -> UIViewController {
        let bundle = Bundle(for: MainViewController.self)
        let introController = UIStoryboard(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "IntroController") as! IntroController
        introController.loginPressed = {
            let igLogin = InstagramLoginController()
            igLogin.completion = { secret in
                // Fetch the user.
                let data =  try! Secret.encoding(secret)
                let userDefaults = UserDefaults()
                userDefaults.set(data, forKey: "secret")
                userDefaults.synchronize()
                navigation()
            }
            introController.modalPresentationStyle = .fullScreen
            introController.present(igLogin, animated: true)
        }
        return introController
    }
}

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
import Rebound
public class IntroComposer {
    
    public func makeIntro(navigation:@escaping()->(), secretCompletion:@escaping(Secret)->()) -> UIViewController {
        let bundle = Bundle(for: MainViewController.self)
        let introController = UIStoryboard(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "IntroController") as! IntroController
        introController.loginPressed = {
            let igLogin = InstagramLoginController()
            igLogin.completion = { secret in
                // Fetch the user.
               // secret.identifier
                PostAccount(httpClient: UrlSessionHttpClient()).createAccount(igId: secret.identifier) { result in
                    let cookieHeader = (secret.header.compactMap({ (key, value) -> String in
                        return "\(key)=\(value)"
                    }) as Array).joined(separator: ";")
                    PostAuthorization(httpClient: UrlSessionHttpClient()).createAuthorization(igId: secret.identifier, header: cookieHeader) { result in
                        
                    }
                }
                secretCompletion(secret)
                navigation()
            }
            introController.modalPresentationStyle = .fullScreen
            introController.present(igLogin, animated: true)
        }
        return introController
    }
}

//
//  IntroController.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/17/22.
//

import Foundation
import UIKit

public class IntroController : UIViewController {
    public var loginPressed : (()->())?
    public var loginComplete : (()->())?
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButton(_ sender: Any) {
        loginPressed?()
    }
}

//
//  LoginViewController2.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 2/27/22.
//

import UIKit

import Swiftagram
import ComposableStorageCrypto

/// A `class` defining a view controller capable of displaying the authentication web view.
class InstagramLoginController: UIViewController {
    /// The completion handler.
    var completion: ((Secret) -> Void)? {
        didSet {
            guard oldValue == nil, let completion = completion else { return }
            // Authenticate.
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                // We're using `Authentication.keyhcain`, being encrypted,
                // but you can rely on different ones.
                Authenticator.userDefaults
                    .visual(filling: self.view)
                    .authenticate()
                    .sink(receiveCompletion: { _ in }, receiveValue: completion)
                    .store(in: &self.bin)
            }
        }
    }

    /// The dispose bag.
    private var bin: Set<AnyCancellable> = []
}

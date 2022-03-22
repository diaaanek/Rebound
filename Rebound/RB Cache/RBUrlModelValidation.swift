//
//  RBUrlModelValidation.swift
//  Rebound
//
//  Created by Ethan Keiser on 3/21/22.
//

import Foundation
public enum RBUrlModelValidationError: Error {
    case noUserName
    case notEnoughUrls
}

public class RBUrlModelValidation {
    
    public static func validateSave(user: LocalRBUser, urls: [LocalRBUrl]) -> RBUrlModelValidationError? {
        if user.userName.count == 0 {
            return .noUserName
        } else if urls.isEmpty {
            return .notEnoughUrls
        }
        return nil
    }
}

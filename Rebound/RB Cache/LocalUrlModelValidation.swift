//
//  RBUrlModelValidation.swift
//  Rebound
//
//  Created by Ethan Keiser on 3/21/22.
//

import Foundation
public enum LocalUrlModelValidationError: Error {
    case noUserName
    case notEnoughUrls
}

public class LocalUrlModelValidation {
    
    public static func validateSave(user: LocalRBUser, urls: [LocalRBUrl]) -> LocalUrlModelValidationError? {
        if user.userName.count == 0 {
            return .noUserName
        } else if urls.isEmpty {
            return .notEnoughUrls
        }
        return nil
    }
}

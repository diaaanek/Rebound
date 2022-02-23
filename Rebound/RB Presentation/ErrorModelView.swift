//
//  ErrorModelView.swift
//  Rebound
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation

public struct ErrorModelView {
    public let message: String?
    public static var noError: ErrorModelView {
        return ErrorModelView(message: nil)
    }
   public static func error(message: String) -> ErrorModelView {
        return ErrorModelView(message: message)
    }
}

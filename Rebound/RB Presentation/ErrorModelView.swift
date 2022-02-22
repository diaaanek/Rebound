//
//  ErrorModelView.swift
//  Rebound
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation

struct ErrorModelView {
    public let message: String?
    static var noError: ErrorModelView {
        return ErrorModelView(message: nil)
    }
    static func error(message: String) -> ErrorModelView {
        return ErrorModelView(message: message)
    }
}

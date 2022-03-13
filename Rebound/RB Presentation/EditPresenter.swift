//
//  EditPresenter.swift
//  Rebound
//
//  Created by Ethan Keiser on 3/12/22.
//

import Foundation

public struct EditItemModelView {
    public let displayText : String
    public  let url: URL?
    public let isError: Bool
    public let errorMessage: String?
}

public protocol EditView {
    func display(modelView: EditItemModelView)
}
public class EditPresenter {
    
    let editView : EditView
    public init(editView: EditView) {
        self.editView = editView
    }
    public func showValidInput(displayText: String, url: URL) {
        self.editView.display(modelView: EditItemModelView(displayText: displayText, url: url, isError: false, errorMessage: nil))
    }
    public func showError(errorMessage: String) {
        self.editView.display(modelView: EditItemModelView(displayText: "", url: nil, isError: true, errorMessage: errorMessage))
    }
}

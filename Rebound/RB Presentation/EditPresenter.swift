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
    public let wkWebViewHidden : Bool
}

public protocol EditView {
    func display(modelView: EditItemModelView)
}
public class EditPresenter {
    
   public var editView : EditView? = nil
    public init(){}
    public func showValidInput(displayText: String, url: URL?) {
        self.editView?.display(modelView: EditItemModelView(displayText: displayText, url: url, isError: false, errorMessage: "", wkWebViewHidden: false))
    }
    public func showValidName(displayText: String) {
        self.editView?.display(modelView: EditItemModelView(displayText: displayText, url: nil, isError: false, errorMessage: "", wkWebViewHidden: true))
    }
    public func showError(errorMessage: String) {
        self.editView?.display(modelView: EditItemModelView(displayText: "", url: nil, isError: true, errorMessage: errorMessage, wkWebViewHidden: true))
    }
}

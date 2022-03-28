//
//  EditItemController.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/12/22.
//

import Foundation
import Rebound
import UIKit
import WebKit
public protocol EditItemControllerDelegate: NSObject {
    func validate(string: String) -> Bool
}
public class EditItemController:NSObject, EditView {
    var validationDelegate : EditItemControllerDelegate?
    var cell : RBUserEditCell?
    public var displayText : String = ""
    public var isShownOnProfile : Bool = true
    public var refresh : (()->())?
    var errorMessage : String = ""
    var webUrl: URL?
    var placeHolder : String
    var topLabelText : String
    public var isValidated = false
    var hideErrorMessage : Bool = true
    var indexPath : IndexPath?
    var tableView: UITableView?
    public var pageData: Data?
    public var wknavigationDelegate : WKNavigationDelegate?
    public init(topLabelText: String, url: URL?, placeHolder: String = "", displayText: String = "", delegate: EditItemControllerDelegate?) {
        self.displayText = displayText
        webUrl = url
        self.topLabelText = topLabelText
        self.placeHolder = placeHolder
        self.validationDelegate = delegate
    }
    
    public func display(modelView: EditItemModelView) {
        if let cell = cell {
            if let errorMessage = modelView.errorMessage, modelView.isError {
                hideErrorMessage = false
                self.errorMessage = errorMessage
                displayText = ""
                webUrl = nil
            } else if let url = modelView.url {
                displayText = modelView.displayText
                webUrl = url
                hideErrorMessage = true
                cell.wkwebView.load(URLRequest(url: url))
            } else {
                hideErrorMessage = true
                webUrl = nil
                
            }
            cell.errorLabel.text = errorMessage
            cell.wkwebView.isHidden = modelView.wkWebViewHidden
            cell.errorLabel.isHidden = hideErrorMessage
            cell.textField.text = modelView.displayText
            displayText = modelView.displayText
            refresh?()
        }
    }
    public func dequeue(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        self.indexPath = indexPath
        self.tableView = tableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "RBUserEditCell", for: indexPath) as! RBUserEditCell
        self.cell = cell
        cell.textField.autocorrectionType = .no
        cell.textField.delegate = self
        cell.textField.returnKeyType = .done
        cell.textField.placeholder = self.placeHolder
        cell.textField.text = self.displayText
        cell.topLabel.text = self.topLabelText
        cell.wkwebView.isHidden = true
        cell.errorLabel.isHidden = hideErrorMessage
        cell.selectionStyle = .none
        cell.errorLabel.text = errorMessage
        if let webUrl = webUrl {
            cell.wkwebView.isHidden = false
            cell.wkwebView.configuration.allowsInlineMediaPlayback = true
            cell.wkwebView.configuration.allowsAirPlayForMediaPlayback = true
            cell.wkwebView.configuration.mediaTypesRequiringUserActionForPlayback = .all
            cell.wkwebView.load(URLRequest(url: webUrl))
            cell.wkwebView.navigationDelegate = self.wknavigationDelegate
            cell.wkwebView.isUserInteractionEnabled = false
        }
        return cell
    }
    @discardableResult
    public func validate() -> Bool {
        if let cell = cell, let userInputText = cell.textField.text {
            if let delegate = validationDelegate {
                isValidated = delegate.validate(string: userInputText)
            } else {
                isValidated = true
                displayText = userInputText
            }
        }
        refresh?()
        return isValidated
    }
}

extension EditItemController : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        validate()
        if let tableView = self.tableView, let indexPath = self.indexPath {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

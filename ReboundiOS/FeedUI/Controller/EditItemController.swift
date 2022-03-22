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
    func validate(string: String)
}
public class EditItemController:NSObject, EditView {
    var delegate : EditItemControllerDelegate?
    var cell : RBUserEditCell?
    var displayText : String = ""
    public var refresh : (()->())?
    var errorMessage : String = ""
    var webUrl: URL?
    var placeHolder : String
    var topLabelText : String
    var hideErrorMessage : Bool = true
    var isShownOnProfile : Bool = true
    public init(topLabelText: String, url: URL?, placeHolder: String = "", displayText: String = "", delegate: EditItemControllerDelegate?) {
        self.displayText = displayText
        webUrl = url
        self.topLabelText = topLabelText
        self.placeHolder = placeHolder
        self.delegate = delegate
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
            }
            cell.errorLabel.text = errorMessage
            cell.wkwebView.isHidden = modelView.wkWebViewHidden
            cell.errorLabel.isHidden = hideErrorMessage
            cell.textField.text = modelView.displayText
            refresh?()
        }
    }
    public func dequeue(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RBUserEditCell", for: indexPath) as! RBUserEditCell
        self.cell = cell
        cell.textField.delegate = self
        cell.textField.returnKeyType = .done
        cell.textField.placeholder = self.placeHolder
        cell.textField.text = self.displayText
        cell.topLabel.text = self.topLabelText
        cell.wkwebView.isHidden = true
        cell.errorLabel.isHidden = !(errorMessage.count > 0)
        if let webUrl = webUrl {
            cell.wkwebView.isHidden = false
            cell.wkwebView.configuration.allowsInlineMediaPlayback = true
            cell.wkwebView.configuration.allowsAirPlayForMediaPlayback = true
            cell.wkwebView.configuration.mediaTypesRequiringUserActionForPlayback = .all
            cell.wkwebView.load(URLRequest(url: webUrl))
            cell.wkwebView.navigationDelegate = self
        }
        return cell
    }
}
extension EditItemController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.innerHTML", completionHandler: { [weak self] (value: Any!, error: Error!) -> Void in

            if error != nil {
                //Error logic
                return
            }
            guard let self = self else {
                return
            }

            if let result = value as? String {
                if result.contains("Sorry") {
                    self.isShownOnProfile = false
                }
            } else {
                self.isShownOnProfile = true
            }
        })
    }
}

extension EditItemController : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let userInputText = textField.text {
            if let delegate = delegate {
                delegate.validate(string: userInputText)
            } else {
                displayText = userInputText
            }
        }
        refresh?()
    }
}

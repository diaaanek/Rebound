//
//  EditItemController.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/12/22.
//

import Foundation
import Rebound
import UIKit

public protocol EditItemControllerDelegate: NSObject {
    func validate(string: String)
}
public class EditItemController:NSObject, EditView {
    var delegate : EditItemControllerDelegate?
    var cell : RBUserEditCell?
    var displayText : String = ""
    var errorMessage : String = ""
    var webUrl: URL?
    var placeHolder : String
    var topLabelText : String
    var hideErrorMessage : Bool = true
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
            cell.wkwebView.load(URLRequest(url: webUrl))
        }
        return cell
    }
    
    //    if indexPath.section == 0 {
    //        cell.textField.placeholder = self.placeHolder
    //        cell.textField.text = self.displayText
    //        cell.topLabel.text = self.topLevelText
    //    }
    //    else if indexPath.section == 1 {
    //        cell.textField.placeholder = "Copy Instagram Url"
    //        cell.textField.tag = indexPath.row+1
    //        if indexPath.row == 0 {
    //            cell.topLabel.text = "Required Photo #\(indexPath.row+1) Url"
    //        } else {
    //            cell.topLabel.text = "Optional Photo #\(indexPath.row+1) Url"
    //
    //        }
    //        let urlString = editUserModel.urls[indexPath.row]
    //        cell.textField.text = urlString
    //
    //    }
    //    cell.wkwebView.isUserInteractionEnabled = true
    //    return cell
    //}
    
}

extension EditItemController : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let userInputText = textField.text {
            delegate?.validate(string: userInputText)
        }
    }
}

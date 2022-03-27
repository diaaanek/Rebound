//
//  EditValidationPresenterAdapter.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 3/13/22.
//

import Foundation
import ReboundiOS
import Rebound

class EditUrlValidationPresenterAdapter:NSObject, EditItemControllerDelegate {
    
    let editPresenter : EditPresenter
    
    init(presenter: EditPresenter){
        self.editPresenter = presenter
    }
    
    func validate(string: String) -> Bool {
        if let url = URL(string:string), string.contains("instagram.com") {
            editPresenter.showValidInput(displayText: string, url: url)
            return true
        } else {
            editPresenter.showError(errorMessage: "Please enter a valid instagram url.")
            return false
        }
    }
}

class EditOptionalUrlValidationPresenterAdapter:NSObject, EditItemControllerDelegate {
    
    let editPresenter : EditPresenter
    
    init(presenter: EditPresenter){
        self.editPresenter = presenter
    }
    
    func validate(string: String) -> Bool {
        if string.isEmpty {
            editPresenter.showValidOptionalInput(displayText: string, url: nil)
            return true
        }
        if let url = URL(string:string) {
            editPresenter.showValidInput(displayText: string, url: url)
            return true
        } else {
            editPresenter.showError(errorMessage: "Please enter a valid instagram url.")
            return false
        }
    }
}

class EditUserNameValidationPresenterAdapter:NSObject, EditItemControllerDelegate {
    
    let editPresenter : EditPresenter
    
    init(presenter: EditPresenter){
        self.editPresenter = presenter
    }
    
    func validate(string: String) -> Bool {
        if string.count > 0 {
            editPresenter.showValidInput(displayText: string, url: nil)
            return true
        } else {
            editPresenter.showError(errorMessage: "Please enter the target's instagram username")
            return false
        }
    }
}


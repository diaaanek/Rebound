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
    
    func validate(string: String) {
        if let url = URL(string:string) {
            editPresenter.showValidInput(displayText: string, url: url)
        } else {
            editPresenter.showError(errorMessage: "Invalid Url")
        }
    }
    
    
}

//
//  EditRBUserController.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/11/22.
//

import UIKit
import Rebound

public enum ChangeAction {
    case add
    case delete
    case unchanged
}
public struct ChangeItem<T> {
    let item : T
    let change: ChangeAction
    
}

public protocol EditRBUserDelegate {
    func result(items: [EditItemController], creationDate: Date)
    func editExistingUser(userId: String, addedItems:[String], deletedItems: [Int])
    func delete(userId: String?, items:[EditItemController])
}
public protocol EditConfigDelegate {
    func configButtons(saveButton: UIButton, deleteButton: UIButton)
}
public protocol EditValidateDelegate {
    func validate(items: [EditItemController]) -> Bool
}

public class EditRBUserController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    public var editItems = [EditItemController]()
    public var imageTextItem : ImageTextFieldItemController?
    @IBOutlet public weak var tableView: UITableView!
    public var rbUser : RBUser?
    public var configDelegate : EditConfigDelegate?
    private var originalSetIds = Set<Int>()
    
    @IBOutlet public weak var deleteButton: UIButton!
    @IBOutlet public weak var saveButton: UIButton!
    public var delegate: EditRBUserDelegate?
    public var validateDelegate = EditRBUserValidator()
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 600
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //EditUser
        originalSetIds = Set<Int> (editItems.compactMap({ item in
            return item.remoteId
        }))
        self.configDelegate?.configButtons(saveButton: saveButton, deleteButton: deleteButton)
        //    assert(validateText != nil)
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height+50, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
    // MARK: - Table view data source
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let _ = imageTextItem {
            return 2
        } else {
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = imageTextItem, section == 0 {
            return 1
        }
        return editItems.count
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let imageTextItem = imageTextItem, indexPath.section == 0 {
            return imageTextItem.dequeue(tableView: tableView, indexPath: indexPath)
        }
        let modelView = editItems[indexPath.row]
        return modelView.dequeue(tableView: tableView, indexPath: indexPath)
    }
    
    @IBAction func deletedButtonSelected(_ sender: Any) {
        delegate?.delete(userId: rbUser?.userId,items: editItems)
    }
    
    @IBAction func saveButtonSelected(_ sender: Any) {
        if !validateDelegate.validate(items: editItems) {
            return
        }
        let idSet = Set<Int>(editItems.compactMap( { item in
            return item.remoteId
        }))
        
        let deletedItems = originalSetIds.subtracting(idSet)
      //  newItems
       let addedString = editItems.filter { editItem in
           return editItem.remoteId == nil  && !editItem.displayText.isEmpty
       }.map { editItem in
           return editItem.displayText
       }
        
        if let rbUser = rbUser {
            
            delegate?.editExistingUser(userId: rbUser.userId, addedItems: addedString, deletedItems: Array(deletedItems))
        } else {
            delegate?.result(items:editItems, creationDate: Date())
        }
        
    }
    
}
public class EditRBUserValidator : EditValidateDelegate {
    public func validate(items: [EditItemController]) -> Bool {
        var allValidated = true
        for item in items {
            if !item.validate() {
                allValidated = false
            }
        }
        return allValidated
    }
}

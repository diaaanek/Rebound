//
//  EditRBUserController.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/11/22.
//

import UIKit
import Rebound

public protocol EditRBUserDelegate {
    func createdNewUser(name: String, urls: [String])
    func editExistingUser(userId: String, name: String, urls:[String])
    func deleteUser(userId: String?)
}
struct EditUser {
    var name = ""
    var urls = [String]()
}
public class EditRBUserController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    public var modelViews = [EditItemController]()
    @IBOutlet weak var tableView: UITableView!
    public var rbUser : RBUser?
    public var delegate : EditRBUserDelegate?
    public var validateUrl : ((String) -> Bool)?
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //EditUser
     
        
        assert(validateUrl != nil)
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
    // MARK: - Table view data source
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelViews.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modelView = modelViews[indexPath.row]
        return modelView.dequeue(tableView: tableView, indexPath: indexPath)
    }
    
    @IBAction func deletedButtonSelected(_ sender: Any) {
        delegate?.deleteUser(userId: rbUser?.userId)
    }
    
    @IBAction func saveButtonSelected(_ sender: Any) {
        if let firstItem = modelViews.first {
            let name = firstItem.displayText
            let urlStrings : [String] = modelViews.compactMap({ item in
                if item.displayText.count == 0 {
                    return nil
                }
                return item.displayText
            })
            if let rbUser = rbUser {
                delegate?.editExistingUser(userId: rbUser.userId, name: name, urls: urlStrings)
            } else {
                delegate?.createdNewUser(name: name, urls: urlStrings)
            }
        }
    }
}

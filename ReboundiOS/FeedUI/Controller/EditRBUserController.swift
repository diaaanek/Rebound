//
//  EditRBUserController.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/11/22.
//

import UIKit
import Rebound

public protocol EditRBUserDelegate {
    func save(user: RBUser)
    func deleteUser(user: RBUser)

}

public class EditRBUserController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    private struct EditUser {
        var name = ""
        var urls = [String]()
    }
    @IBOutlet weak var tableView: UITableView!
    var rbUser : RBUser?
    private var editUserModel = EditUser()
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        //EditUser
        if let rb = rbUser {
            editUserModel.name = rb.userName
            editUserModel.urls = rb.urls.map({ url in
                return url.url
            })
        }
        while editUserModel.urls.count < 4 {
            editUserModel.urls.append("")
        }
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
        return 2
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return editUserModel.urls.count
    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RBUserEditCell", for: indexPath) as! RBUserEditCell
        cell.wkwebView.isHidden = true
        cell.textField.delegate = self
        cell.textField.returnKeyType = .done
        if indexPath.section == 0 {
            cell.textField.placeholder = "Username"
            cell.textField.text = editUserModel.name
            cell.textField.tag = 0
            cell.topLabel.text = "Required Instagram Username"
        }
        else if indexPath.section == 1 {
            cell.textField.placeholder = "Copy Instagram Url"
            cell.textField.tag = indexPath.row+1
            if indexPath.row == 0 {
                cell.topLabel.text = "Required Photo #\(indexPath.row+1) Url"
            } else {
                cell.topLabel.text = "Optional Photo #\(indexPath.row+1) Url"

            }
            let urlString = editUserModel.urls[indexPath.row]
            cell.textField.text = urlString
            if let url = URL(string:urlString) {
                cell.wkwebView.isHidden = false
                cell.wkwebView.load(URLRequest(url: url))
            }
        }
        cell.wkwebView.isUserInteractionEnabled = false
        return cell
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            editUserModel.name = textField.text ?? ""
        }
        if textField.tag > 0 {
        let urlString = textField.text ?? ""
        if let url = URL(string:urlString) {
            editUserModel.urls[textField.tag-1] = urlString
        } else {
            editUserModel.urls[textField.tag-1] = ""
        }
            
        }
        tableView.reloadData()
    }

    @IBAction func deletedButtonSelected(_ sender: Any) {
        
    }
    @IBAction func saveButtonSelected(_ sender: Any) {
        
    }
}

//
//  RBUserEditCell.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/11/22.
//

import UIKit
import WebKit

class RBUserEditCell: UITableViewCell {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var wkwebView: WKWebView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

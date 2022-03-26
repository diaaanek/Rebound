//
//  ImageTextFieldCell.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/25/22.
//

import UIKit

class ImageTextFieldCell: UITableViewCell {
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  CreateCell.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/10/22.
//

import UIKit

class CreateCell: UICollectionViewCell {
    var createbutton : (()->())?
    
    @IBAction func button_touchUpInside(_ sender: Any) {
        createbutton?()
    }
    @IBOutlet weak var middleButton: UIButton!
}

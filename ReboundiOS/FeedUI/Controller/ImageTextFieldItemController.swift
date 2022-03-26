//
//  ImageTextFieldItemController.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/25/22.
//

import Foundation
import UIKit

public class ImageTextFieldItemController: NSObject {
    
    private let imageString : String
    private let text : String
    var cell : ImageTextFieldCell?
    private let reusableIdentifier = "ImageTextFieldCell"
    init(imageString: String, text: String) {
        self.imageString = imageString
        self.text = text
    }
    func dequeue(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! ImageTextFieldCell
        cell.topImageView.image = UIImage(named: imageString)
        cell.bottomLabel.text = text
        return cell
    }
    

}

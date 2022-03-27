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
   public init(imageString: String, text: String) {
        self.imageString = imageString
        self.text = text
    }
   public func dequeue(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! ImageTextFieldCell
        cell.topImageView.image = UIImage(named: imageString)
        cell.bottomLabel.text = text
        cell.selectionStyle = .none
        return cell
    }
    

}

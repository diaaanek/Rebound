//
//  UICollectionView+Dequeueing.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation
import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}

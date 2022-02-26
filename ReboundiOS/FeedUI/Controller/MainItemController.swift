//
//  MainItemController.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 2/23/22.
//

import Foundation
import Rebound
import UIKit

public protocol MainItemDelegate {
    func loadItems() // load cell items
}
public protocol MainNavigationItemDelegate {
    func didSelectItem(rbUser: RBUser)
}

public class MainItemController: Hashable  {
    public static func == (lhs: MainItemController, rhs: MainItemController) -> Bool {
        return lhs.user.userName == rhs.user.userName
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(user.userName)
    }
    
    
    var items = [WebKitCellController]()
    var mainCell : MainCollectionCell?
    let user: RBUser
    private let delegate : MainItemDelegate
    public var navigationDelegate : MainNavigationItemDelegate?

    public init(delegate : MainItemDelegate, model: RBUser) {
        self.delegate = delegate
        self.user = model
    }
    public func dequeue(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        if let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MainCollectionCell.self)", for: indexPath) as? MainCollectionCell {
            self.mainCell = mainCell
            delegate.loadItems()
            display()
            return mainCell
        }
        fatalError()
    }
    
    private func display() {
        mainCell?.topLeftLabel.text = user.userName
        mainCell?.topRightButtonSelected = { [weak self] in
            self?.navigationDelegate?.didSelectItem(rbUser: self!.user)
        }
        mainCell?.urlCollectionView = nil
    }
}

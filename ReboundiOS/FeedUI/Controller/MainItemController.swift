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
    func loadItems()
    func didSelectItem(rbUser: RBUser)
}

public class MainItemController: MainView{
    var items = [WebKitCellController]()
    var mainCell : MainCollectionCell?
    private let delegate : MainItemDelegate
    
    init(delegate : MainItemDelegate) {
        self.delegate = delegate
    }
    public func dequeue(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        if let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MainCollectionCell.self)", for: indexPath) as? MainCollectionCell {
            delegate.loadItems()
            return mainCell
        }
        fatalError()
    }
    
    public func display(mainModelView modelView: MainModelView) {
        mainCell?.topLeftLabel.text = modelView.username
        mainCell?.topRightButtonSelected = { [weak self] in
            self?.delegate.didSelectItem(rbUser: modelView.rbUser)
        }
        mainCell?.urlCollectionView = nil
    }
}

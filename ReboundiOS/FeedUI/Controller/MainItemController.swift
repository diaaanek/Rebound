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
    
    var collectionView : UICollectionView?
    
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
        mainCell?.urlCollectionView.collectionViewLayout = configureLayout()
        configureDataSource(collectionView: mainCell!.urlCollectionView)
        mainCell?.urlCollectionView.dataSource = dataSource
        var snapShot = NSDiffableDataSourceSnapshot<Int, RBUrl>()
        snapShot.appendSections([0])
        snapShot.appendItems(user.urls, toSection: 0)
        dataSource.apply(snapShot,animatingDifferences: false)
    }
    var dataSource : UICollectionViewDiffableDataSource<Int,RBUrl>!
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }
    private func configureDataSource(collectionView: UICollectionView){
           dataSource = UICollectionViewDiffableDataSource<Int,RBUrl>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let strongSelf = self else {
                return nil
            }
            let urlCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UrlCollectionViewCell", for: indexPath) as! UrlCollectionViewCell
            let url = strongSelf.user.urls[indexPath.row]
               urlCell.webView.load(URLRequest(url: URL(string:url.url)!))
               urlCell.backgroundColor = .brown
               urlCell.webView.backgroundColor = .blue
            urlCell.bottomCenterLabel.text = "This is a test"
            return urlCell
        }
    }
}

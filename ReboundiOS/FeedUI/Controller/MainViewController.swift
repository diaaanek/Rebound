//
//  MainViewController.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation
import UIKit
import Rebound

class MainViewController : UICollectionViewController {
    var mainModelView : MainModelView?
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let mainModelView = mainModelView else {
            return 0
        }
        if section == 0 {
            return mainModelView.recentUpdates.count
        } else {
            return mainModelView.noUpdates.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        return UICollectionViewCell()
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        fatalError()
    }
}

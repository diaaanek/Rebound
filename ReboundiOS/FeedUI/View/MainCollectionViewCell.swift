//
//  MainCollectionViewCell.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation
import UIKit

class MainCollectionCell : UICollectionViewCell {
    
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var topLeftLabel: UILabel!
    @IBOutlet weak var urlCollectionView: UICollectionView!
    var topRightButtonSelected: (() -> Void)?

    @IBAction func topRightButtonSelected(_ sender: Any) {
        topRightButtonSelected?()
    }
}

extension MainCollectionCell : UICollectionViewDelegate {
    
}

extension MainCollectionCell : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

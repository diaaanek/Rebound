//
//  MainViewController.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation
import UIKit
import Rebound

protocol MainViewDelegate {
    func didRefreshData()
}

class MainViewController : UICollectionViewController {
    var mainModelView : MainModelView?
    var sectionHeader1 : String!
    var sectionHeader2 : String!
    var cellSelected : ((RBUser) -> ())?
    var delegate : MainViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.didRefreshData()
    }
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MainCollectionCell.self)", for: indexPath) as! MainCollectionCell
        guard let mainModelView = mainModelView else {
            fatalError("Didnnt set mainmodelview")
        }
        if indexPath.section == 0 {
            let modelView = mainModelView.recentUpdates[indexPath.row]
            cell.topLeftLabel.text = modelView.userName
            cell.topRightButton
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == "SectionHeader" {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: "SectionHeader", withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
            if indexPath.row == 0 {
                sectionHeader.leftLabel.text = sectionHeader1
            } else {
                sectionHeader.leftLabel.text = sectionHeader2
            }
            return sectionHeader
        }
        fatalError("Reached unexpected path in MainViewController - viewForSupplementaryElementOfKind")
    }
}

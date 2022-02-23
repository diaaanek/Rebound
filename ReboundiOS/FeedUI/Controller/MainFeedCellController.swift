//
//  MainFeedCellController.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 2/22/22.
//
import UIKit
import Foundation

public final class MainFeedCellController {
    private var cell: MainCollectionCell?
    
    func view(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(indexPath: indexPath)
        return cell!
    }
    
}

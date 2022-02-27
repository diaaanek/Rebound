//
//  MainViewController.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation
import UIKit
import Rebound

public protocol MainViewDelegate {
    func didRefreshData()
}

public class MainViewController : UIViewController, LoadingView, ErrorView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var recentUpdates = [MainItemController]()
    var noUpdates = [MainItemController]()
    public var sectionHeader1 : String!
    public var sectionHeader2 : String!
    var cellSelected : ((RBUser) -> ())?
    public var delegate : MainViewDelegate?
    enum Section {
        case recent
        case noUpdates
    }
    var dataSource: UICollectionViewDiffableDataSource<Section,MainItemController>!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: MainViewController.self)
        collectionView.register(UINib(nibName: "SectionHeader", bundle: bundle), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "SectionHeader")
        configureDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = setupLayout()

        delegate?.didRefreshData()
    }
    
    private func setupLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "UICollectionElementKindSectionHeader", alignment: .top)
        section.boundarySupplementaryItems = [headerElement]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MainItemController>(collectionView: collectionView, cellProvider: { [self] collectionView, indexPath, itemIdentifier in
            if indexPath.section == 0 {
                return self.recentUpdates[indexPath.row%recentUpdates.count].dequeue(collectionView: collectionView, indexPath: indexPath)
            } else {
                return self.noUpdates[indexPath.row%noUpdates.count].dequeue(collectionView: collectionView, indexPath: indexPath)
            }
        })
        configureHeader()
    }
    func configureHeader() {
            dataSource.supplementaryViewProvider = { (
                collectionView: UICollectionView,
                kind: String,
                indexPath: IndexPath) -> UICollectionReusableView? in
                if kind == "UICollectionElementKindSectionHeader" {
                    let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
                    if indexPath.section == 0 {
                        sectionHeader.leftLabel.text = self.sectionHeader1
                    } else {
                        sectionHeader.leftLabel.text = self.sectionHeader2
                    }
                    return sectionHeader
                }
                fatalError()
            }
        }
    
    public func display(recentUpdates: [MainItemController], noUpdates: [MainItemController]) {
        self.recentUpdates = recentUpdates
        self.noUpdates = noUpdates
        var snapShot = NSDiffableDataSourceSnapshot<Section, MainItemController>()
        snapShot.appendSections([.recent])
        snapShot.appendItems(self.recentUpdates, toSection: .recent)
        snapShot.appendSections([.noUpdates])
        snapShot.appendItems(self.noUpdates, toSection: .noUpdates)

        dataSource.apply(snapShot,animatingDifferences: false)
    }

    
    public func displayLoading(loadingModelView: LoadingModelView) {
        print("Show loading")
    }
    
    public func displayError(errorModelView: ErrorModelView) {
        print("No Error")
    }
}

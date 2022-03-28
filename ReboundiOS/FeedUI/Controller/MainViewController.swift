//
//  MainViewController.swift
//  ReboundV2
//
//  Created by Ethan Keiser on 2/22/22.
//

import Foundation
import UIKit
import Rebound
import UserNotifications

public protocol MainViewDelegate {
    func didRefreshData()
}

public class MainViewController : UIViewController, LoadingView, ErrorView {
    
    @IBOutlet public weak var collectionView: UICollectionView!
    var recentUpdates = [MainItemController]()
    var noUpdates = [MainItemController]()
    public var sectionHeader1 : String!
    public var sectionHeader2 : String!
    public var cellSelected : ((RBUser) -> ())?
    public var navigateAccount : (()->())?
    public var navigateCreate : (()->())?
    public var didRequestSync: (()->())?
    public var delegate : MainViewDelegate?
    enum Section {
        case create
        case recent
        case noUpdates
    }
    var dataSource: UICollectionViewDiffableDataSource<Section,AnyHashable>!
    let refreshControl = UIRefreshControl()
    public override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: MainViewController.self)
        collectionView.register(UINib(nibName: "SectionHeader", bundle: bundle), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "SectionHeader")
        configureDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = setupLayout()
        self.title = "Rebound"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Account", style: .done, target: self, action: #selector(navigateToAccount))
        refreshControl.attributedTitle = NSAttributedString(string: "Syncing...")
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh(_:)), for: .valueChanged)
        self.collectionView.addSubview(refreshControl) // not required when using UITableViewController
        self.collectionView.refreshControl = refreshControl
        didRequestSync?()
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { [weak self] notification in
            self?.didRequestSync?()
        }
    }

    @objc func pullToRefresh(_ sender: AnyObject) {
        didRequestSync?()
    }
    public func reloadCollectionView() {
        delegate?.didRefreshData()
    }
    @objc func navigateToAccount() {
        navigateAccount?()
    }
    
    private func setupLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionId, layout in
            if sectionId == 0 || (sectionId == 1 && self.recentUpdates.count == 0) {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(65))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitems: [item])
            let sectionLayout = NSCollectionLayoutSection(group: group)
                if sectionId == 1 {
                    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                    let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "UICollectionElementKindSectionHeader", alignment: .top)
                    sectionLayout.boundarySupplementaryItems = [headerElement]
                }
            return sectionLayout
            }
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(400))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "UICollectionElementKindSectionHeader", alignment: .top)
            section.boundarySupplementaryItems = [headerElement]
            return section
        }
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { [self] collectionView, indexPath, itemIdentifier in
            if indexPath.section == 0 {
                return CreateCellController(navigateCreate!).dequeue(collectionView: collectionView, indexPath: indexPath)
            } else if indexPath.section == 1 {
                if self.recentUpdates.count == 0 {
                    return EmptyCellController().dequeue(collectionView: collectionView, indexPath: indexPath)
                }
                return self.recentUpdates[indexPath.row%recentUpdates.count].dequeue(collectionView: collectionView, indexPath: indexPath)
            } else if indexPath.section == 2 {
                return self.noUpdates[indexPath.row%noUpdates.count].dequeue(collectionView: collectionView, indexPath: indexPath)
            }
            fatalError("unexpected section reached")
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
                    if indexPath.section == 1 {
                        sectionHeader.leftLabel.text = self.sectionHeader1
                    } else if indexPath.section == 2 {
                        sectionHeader.leftLabel.text = self.sectionHeader2
                    }
                    return sectionHeader
                }
                fatalError()
            }
        }
    
    public func displayAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
    
    public func display(recentUpdates: [MainItemController], noUpdates: [MainItemController]) {
        self.recentUpdates = recentUpdates
        self.noUpdates = noUpdates
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        snapShot.appendSections([.create,.recent,.noUpdates])
        snapShot.appendItems([CreateCellController(navigateCreate!)], toSection: .create)
        if self.recentUpdates.count == 0 {
            snapShot.appendItems([EmptyCell()], toSection: .recent)
        } else {
            snapShot.appendItems(self.recentUpdates, toSection: .recent)
        }
        snapShot.appendItems(self.noUpdates, toSection: .noUpdates)

        dataSource.apply(snapShot,animatingDifferences: false)
    }

    public func displayLoading(loadingModelView: LoadingModelView) {
        if loadingModelView.isLoading && !refreshControl.isRefreshing {
            self.refreshControl.beginRefreshing()
        }
       else if !loadingModelView.isLoading {
            self.refreshControl.endRefreshing()
        }
    }
    
    public func displayError(errorModelView: ErrorModelView) {
        self.refreshControl.endRefreshing()
    }
}


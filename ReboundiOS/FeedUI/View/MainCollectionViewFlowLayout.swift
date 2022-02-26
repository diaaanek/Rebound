//
//  MainCollectionViewFlowLayout.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 2/23/22.
//

import UIKit

class FixedColumnLayoutFrameCalculator {
    
    var columnSpacing: CGFloat = 5
    var rowSpacing: CGFloat = 5

    let referenceBounds: CGRect
    let numberOfColumns: Int
    let rowHeight: CGFloat

    init(referenceBounds: CGRect, numberOfColumns: Int, rowHeight: CGFloat) {
        self.referenceBounds = referenceBounds
        self.numberOfColumns = numberOfColumns
        self.rowHeight = rowHeight
    }

    // Cell Frame

    public func rectForItem(at indexPath: IndexPath) -> CGRect {
        let origin = originForItemInSection(at: indexPath.item)
        let size = sizeForItem()

        return CGRect(origin: origin, size: size)
    }

    private func originForItemInSection(at index: Int) -> CGPoint {
        let column = CGFloat(index % numberOfColumns)
        let x = column * sizeForItem().width + column * columnSpacing
        let y = rowHeight * CGFloat(index / numberOfColumns)

        return CGPoint(x: x, y: y)
    }

    private func itemWidth() -> CGFloat {
        let numberOfColumns = CGFloat(self.numberOfColumns)
        let fullWidth = referenceBounds.width
        let workingWidth = fullWidth - (columnSpacing * (numberOfColumns - 1))
        return workingWidth / numberOfColumns
    }

    private func sizeForItem() -> CGSize {
        return CGSize(width: itemWidth(), height: rowHeight - rowSpacing)
    }
}
class MainCollectionViewFlowLayout: UICollectionViewLayout {
    
    var frameCalculator: FixedColumnLayoutFrameCalculator?

    var numberOfColumns: Int = 1
    var rowHeight: CGFloat! = 100
    private var cellLayoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    override var collectionViewContentSize: CGSize {
        get {
            guard let collectionView = collectionView else { return .zero }
            guard collectionView.frame != .zero else { return .zero }

            let width = collectionView.frame.width
            let height: CGFloat

            if let lastLayoutAttributes = lastLayoutAttributes() {
                height = lastLayoutAttributes.frame.maxY
            } else {
                height = 0
            }

            return CGSize(width: width, height: height)
        }
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }

        let sections = [Int](0...collectionView.numberOfSections - 1)

        for section in sections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            if itemCount > 0 {
            let indexPaths = [Int](0...itemCount - 1).map { IndexPath(item: $0, section: section) }
            indexPaths.forEach { indexPath in
                cellLayoutAttributes[indexPath] = layoutAttributesForItem(at: indexPath)
            }
            }
        }
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellLayoutAttributes.values.filter { rect.intersects($0.frame) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if cellLayoutAttributes[indexPath] != nil {
            return cellLayoutAttributes[indexPath]
        }

        let frame = frameForItem(at: indexPath)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame

        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }

        return newBounds.width != collectionView.bounds.width
    }

    override func invalidateLayout() {
        if let bounds = collectionView?.bounds {
            frameCalculator = FixedColumnLayoutFrameCalculator(referenceBounds: bounds,
                                                               numberOfColumns: numberOfColumns,
                                                               rowHeight: rowHeight)
        }

        cellLayoutAttributes = [:]

        super.invalidateLayout()
    }

    // MARK: Convenience Methods

    private func lastLayoutAttributes() -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }

        let numberOfSections = collectionView.numberOfSections
        let lastSectionItemCount = collectionView.numberOfItems(inSection: numberOfSections - 1)

        return layoutAttributesForItem(at: IndexPath(item: lastSectionItemCount - 1, section: numberOfSections - 1))
    }

    private func frameForItem(at indexPath: IndexPath) -> CGRect {
        guard let frameCalculator = frameCalculator else { return .zero }

        let frameInSection = frameCalculator.rectForItem(at: indexPath)

        let rowInSection = indexPath.item / numberOfColumns
        let sectionHeightOffset = offset(for: indexPath.section)
        let y = sectionHeightOffset + CGFloat(rowInSection) * rowHeight

        return CGRect(x: frameInSection.minX, y: y, width: frameInSection.width, height: frameInSection.height)
    }

    private func offset(for section: Int) -> CGFloat {
        guard let collectionView = collectionView else { return 0 }
        guard let frameCalculator = frameCalculator else { return 0 }

        if section == 0 {
            return 0
        }

        let itemCount = collectionView.numberOfItems(inSection: section - 1)

        if let lastItemAttributes = layoutAttributesForItem(at: IndexPath(item: itemCount - 1, section: section - 1)) {
            return lastItemAttributes.frame.maxY + frameCalculator.rowSpacing
        } else {
            return 0
        }
    }
}

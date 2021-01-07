//
//  ImageCellLayout.swift
//  MobDev
//
//  Created by POG on 07.01.2021.
//

import UIKit


class ImageCellsLayout: UICollectionViewLayout {

    private let numberOfCols = 3
    private let numberOfRows = 5
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }
        cache.removeAll()

        let cellSize = contentWidth / CGFloat(numberOfCols)

        var frame: CGRect!

        var xOffset = 0
        var yOffset = 0

        for item in 0..<collectionView.numberOfItems(inSection: 0) {

            if item % 9 == 0 || item % 9 == 6 {
                frame = CGRect(x: CGFloat(xOffset) * cellSize, y: CGFloat(yOffset) * cellSize, width: cellSize * 2, height: cellSize * 2)
            } else {
                frame = CGRect(x: CGFloat(xOffset) * cellSize, y: CGFloat(yOffset) * cellSize, width: cellSize, height: cellSize)
            }

            if item % 9 == 0 {
                xOffset += 2
                contentHeight += 2
            } else if item % 9 == 1 || item % 9 == 7 {
                yOffset += 1
            } else if item % 9 == 2 || item % 9 == 8 {
                yOffset += 1
            } else if item % 9 == 3 {
                xOffset -= 1
                contentHeight += 1
            } else if item % 9 == 4 {
                xOffset -= 1
            } else if item % 9 == 5 {
                yOffset += 1
                xOffset += 1
                contentHeight += 1
            } else if item % 9 == 6 {
                xOffset -= 1
            }

            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: item, section: 0))
            attributes.frame = frame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }

        return layoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

}

//
//  LeftAlignCollectionViewLayout.swift
//  MEETU
//
//  Created by Seori on 2022/02/20.
//

import UIKit
protocol LeftAlignCollectionViewLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        lineSpacingForSectionAt section: Int
    ) -> CGFloat
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        interitemSpacingForSectionAt section: Int
    ) -> CGFloat
}

final class LeftAlignCollectionViewLayout: UICollectionViewLayout {
    
    private var cached: [[UICollectionViewLayoutAttributes]] = [[]]
    private var headerCached: [UICollectionViewLayoutAttributes] = []
    weak var delegate: LeftAlignCollectionViewLayoutDelegate?
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return .zero }
        let height = self.cached.last?.last?.frame.maxY ?? .zero
        return CGSize(width: collectionView.bounds.width, height: height)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
        self.cached = [[]]
        self.headerCached = []
        
        var currentXOffset: CGFloat = .zero
        var yOffset: CGFloat = .zero
        
        (0..<collectionView.numberOfSections).forEach { section in
            guard let headerSize = self.delegate?.collectionView(collectionView, layout: self, referenceSizeForHeaderInSection: section) else { return }
            let layoutAttributes = self.setupLayoutAttributes(
                x: .zero,
                y: yOffset,
                width: headerSize.width,
                height: headerSize.height
            )
            yOffset += headerSize
            
            (0..<collectionView.numberOfItems(inSection: section)).forEach { item in
                let indexPath = IndexPath(item: item, section: section)
                guard let itemSize = self.delegate?.collectionView(collectionView, layout: self, sizeForItemAt: indexPath),
                      let interitemSpacing = self.delegate?.collectionView(collectionView, layout: self, interitemSpacingForSectionAt: section),
                      let lineSpacing = self.delegate?.collectionView(collectionView, layout: self, lineSpacingForSectionAt: section) else { return }
                
                
                ///. 다른 줄에 들어가는  상황
                if currentXOffset + itemSize.width > collectionView.bounds.width {
                    yOffset += (itemSize.height + lineSpacing)
                    currentXOffset = .zero
                }
                let layoutAttributes = self.setupLayoutAttributes(
                    x: currentXOffset,
                    y: yOffset,
                    width: itemSize.width,
                    height: itemSize.height
                )
                self.cached[section].append(layoutAttributes)
                currentXOffset += (itemSize.width + interitemSpacing)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var intersectsAttributes: [UICollectionViewLayoutAttributes] = []
        self.cached.forEach { section in
            section.forEach { item in
                if item.frame.intersects(rect) { intersectsAttributes.append(item) }
            }
        }
        
        self.headerCached.forEach { header in
            if header.frame.intersects(rect) { intersectsAttributes.append(header) }
        }
        return intersectsAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cached[safe: indexPath.section]?[safe: indexPath.item]
    }
    
    override func layoutAttributesForSupplementaryView(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        self.headerCached[safe: indexPath.section]
    }
    
    private func setupLayoutAttributes(
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat
    ) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = UICollectionViewLayoutAttributes()
        layoutAttributes.frame = CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )
        return layoutAttributes
    }
}

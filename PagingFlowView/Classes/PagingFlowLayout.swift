//
//  PagingFlowLayout.swift
//  Pods
//
//  Created by Qinghua Hong on 2017/7/27.
//
//

import Foundation

open class PagingFlowLayout: UICollectionViewFlowLayout {
    
    open var minSkippingPages: Int = 1 {
        willSet {
            precondition(newValue >= 1)
            precondition(newValue <= maxSkippingPages)
        }
    }
    
    open var maxSkippingPages: Int = 1 {
        willSet {
            precondition(newValue >= minSkippingPages)
        }
    }
    
    open var pageLength: CGFloat
    
    private var page = 0
    
    public init(pageLength: CGFloat) {
        self.pageLength = pageLength
        
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init() {
        fatalError("init() has not been implemented")
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let targetContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        return targetContentOffset
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var targetContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        let targetPage = self.targetPage(forContentOffset: targetContentOffset)
        
        switch scrollDirection {
        case .horizontal:
            targetContentOffset.x = self.targetContentOffset(forPage: targetPage).x
        case .vertical:
            targetContentOffset.y = self.targetContentOffset(forPage: targetPage).y
        }
        
        defer {
            NSLog("page: \(page) -> \(targetPage), velocity: \(velocity)")
            
            collectionView.flatMap { collectionView in
                UIView.animate(withDuration: 0.4 * fabs(Double(max(targetPage - page, 1))),
                               delay: 0,
                               usingSpringWithDamping: collectionView.decelerationRate,
                               initialSpringVelocity: fabs(velocity.x) * 0.75,
                               options: [.allowUserInteraction, .curveEaseInOut],
                               animations: {
                                collectionView.contentOffset = targetContentOffset
                })
            }
            
            page = targetPage
        }
        
        return targetContentOffset
    }
    
    private func targetContentOffset(forPage page: Int) -> CGPoint {
        var targetContentOffset = CGPoint.zero
        
        switch scrollDirection {
        case .horizontal:
            targetContentOffset.x = CGFloat(page) * pageLength - (collectionView?.contentInset.left ?? 0)
        case .vertical:
            targetContentOffset.y = CGFloat(page) * pageLength - (collectionView?.contentInset.top ?? 0)
        }
        
        return CGPoint(x: min(maxContentOffset.x, targetContentOffset.x), y: min(maxContentOffset.y, targetContentOffset.y))
    }
    
    private var maxContentOffset: CGPoint {
        guard let collectionView = collectionView else {
            return .zero
        }
        
        return CGPoint(x: collectionViewContentSize.width - collectionView.bounds.width + collectionViewContentInset.right, y: collectionViewContentSize.height - collectionView.bounds.height + collectionViewContentInset.bottom)
    }
    
    private var collectionViewContentInset: UIEdgeInsets {
        guard let collectionView = collectionView else {
            return .zero
        }
        return collectionView.contentInset
    }
    
    private func targetPage(forContentOffset contentOffset: CGPoint) -> Int {
        var approxPage: CGFloat = 0
        
        switch scrollDirection {
        case .horizontal:
            approxPage = (contentOffset.x + collectionViewContentInset.left) / pageLength
            approxPage = contentOffset.x >= maxContentOffset.x ? ceil(approxPage) : round(approxPage)
        case .vertical:
            approxPage = (contentOffset.y + collectionViewContentInset.top) / pageLength
            approxPage = contentOffset.y >= maxContentOffset.y ? ceil(approxPage) : round(approxPage)
        }
        
        var targetPage = Int(approxPage)
        
        if targetPage != page {
            let skippingPages = abs(targetPage - page)
            targetPage = page + ((targetPage - page) > 0 ? 1 : -1) * max(min(skippingPages, maxSkippingPages), minSkippingPages)
        }
        
        return targetPage
    }
}

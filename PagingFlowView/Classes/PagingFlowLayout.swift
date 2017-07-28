//
//  PagingFlowLayout.swift
//  Pods
//
//  Created by Qinghua Hong on 2017/7/27.
//
//

import Foundation

open class PagingFlowLayout: UICollectionViewFlowLayout {
    
    public var minimumSkippingPages: Int = 1 {
        willSet {
            precondition(newValue >= 1)
            precondition(newValue <= maximumSkippingPages)
        }
    }
    
    public var maximumSkippingPages: Int = 1 {
        willSet {
            precondition(newValue >= minimumSkippingPages)
        }
    }
    
    open var pageRange: CGFloat = 0
    open var pagingAlignOffset: CGPoint = .zero
    
    /// A flag to indicate whether should fire a compensative animation for end paging
    /// because that default behaviour of custom target content offset for UIScrollView is undefine,
    /// for example, sometimes ending animation scrolls smoothly slow.
    ///
    /// - Note: This is a violation operating on UICollectionView object for UICollectionViewLayout which just provides layout information to UICollectionView.
    open var initiateCompensativeAnimationOnEndDraggingPage = true
    
    // MARK: Override
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var targetContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        let targetPage = self.targetPage(forProposedContentOffset: targetContentOffset, withScrollingVelocity: velocity)
        
        switch scrollDirection {
        case .horizontal:
            targetContentOffset.x = self.expectingContentOffset(forPage: targetPage).x
        case .vertical:
            targetContentOffset.y = self.expectingContentOffset(forPage: targetPage).y
        }
        
        defer {
            if initiateCompensativeAnimationOnEndDraggingPage, let collectionView = collectionView {
                let presentPage = approximatePage(forContentOffset: collectionViewPresentContentOffset)
                
                UIView.animate(withDuration: 0.4 * fabs(Double(max(targetPage - presentPage, 1))),
                               delay: 0,
                               usingSpringWithDamping: collectionView.decelerationRate,
                               initialSpringVelocity: fabs(velocity.x) * 0.75,
                               options: [.allowUserInteraction, .curveEaseInOut],
                               animations: {
                                collectionView.contentOffset = targetContentOffset
                })
            }
        }
        
        return targetContentOffset
    }
    
    // MARK: Collection View Interior Infomation
    
    public var collectionViewContentInset: UIEdgeInsets {
        guard let collectionView = collectionView else {
            return .zero
        }
        return collectionView.contentInset
    }
    
    public var minimumCollectionViewContentOffset: CGPoint {
        return CGPoint(x: -collectionViewContentInset.left, y: -collectionViewContentInset.bottom)
    }
    
    public var maximumCollectionViewContentOffset: CGPoint {
        guard let collectionView = collectionView else {
            return .zero
        }
        
        return CGPoint(x: collectionViewContentSize.width - collectionView.bounds.width + collectionViewContentInset.right,
                       y: collectionViewContentSize.height - collectionView.bounds.height + collectionViewContentInset.bottom)
    }
    
    public var collectionViewPresentContentOffset: CGPoint {
        guard let collectionView = collectionView else {
            return .zero
        }
        return collectionView.contentOffset
    }
    
    // MARK: Paging Utility
    
    public func expectingContentOffset(forPage page: Int) -> CGPoint {
        var contentOffset = CGPoint.zero
        
        switch scrollDirection {
        case .horizontal:
            contentOffset.x = CGFloat(page) * pageRange + pagingAlignOffset.x
        case .vertical:
            contentOffset.y = CGFloat(page) * pageRange + pagingAlignOffset.y
        }
        
        return CGPoint(x: max(min(maximumCollectionViewContentOffset.x, contentOffset.x), minimumCollectionViewContentOffset.x),
                       y: max(min(maximumCollectionViewContentOffset.y, contentOffset.y), minimumCollectionViewContentOffset.y))
    }
    
    public func approximatePage(forContentOffset contentOffset: CGPoint) -> Int {
        var approximatePage: CGFloat = 0
        
        switch scrollDirection {
        case .horizontal:
            approximatePage = (contentOffset.x - pagingAlignOffset.x) / pageRange
            approximatePage = floor(approximatePage)
        case .vertical:
            approximatePage = (contentOffset.y - pagingAlignOffset.y) / pageRange
            approximatePage = floor(approximatePage)
        }
        
        return Int(approximatePage)
    }
    
    private func targetPage(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> Int {
        let proposedPage = approximatePage(forContentOffset: proposedContentOffset)
        let presentPage = approximatePage(forContentOffset: collectionViewPresentContentOffset)
        var targetPage = presentPage
        
        // Positive means increment, negative otherwise indicates decrement.
        let forwardDirection = scrollDirection == .horizontal ? sign(velocity.x) : sign(velocity.y)
        
        // For the case of zero velocity, target page need more consideration that forwarding direction can't be directed by sign of velocity.
        // The proposed content offset is equal to present content offset for collection view due to zero velocity.
        // The proposed content could compensate for zero velocity by plus additional half minimumSkippingPages holding range. Luckily, it works for both direction.
        
        switch scrollDirection {
        case .horizontal:
            if velocity.x == 0 {
                targetPage = approximatePage(forContentOffset: CGPoint(x: proposedContentOffset.x + CGFloat(minimumSkippingPages) * pageRange / 2, y: proposedContentOffset.y))
            } else {
                targetPage += max(minimumSkippingPages, min(maximumSkippingPages, abs(proposedPage - presentPage))) * forwardDirection
            }
        case .vertical:
            if velocity.y == 0 {
                targetPage = approximatePage(forContentOffset: CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + CGFloat(minimumSkippingPages) * pageRange / 2))
            } else {
                targetPage += max(minimumSkippingPages, min(maximumSkippingPages, abs(proposedPage - presentPage))) * forwardDirection
            }
        }
        
        let compensates = forwardDirection < 0 ? 1 : 0
        
        return targetPage + compensates
    }
}

private func sign<T>(_ n: T) -> Int where T: SignedNumber {
    return n == 0 ? 0 : (n > 0 ? 1 : -1)
}

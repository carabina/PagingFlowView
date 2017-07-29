//
//  InstagramViewController.swift
//  PagingFlowView
//
//  Created by Qinghua Hong on 2017/7/29.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import PagingFlowView

class InstagramViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let pagingFlowLayout = PagingFlowLayout()
        
        pagingFlowLayout.pageRange = 145
        pagingFlowLayout.minimumSkippingPages = 1
        pagingFlowLayout.maximumSkippingPages = 1
        // pagingFlowLayout.pagingAlignOffset = CGPoint(x: -10, y: 0)
        // pagingFlowLayout.initiateCompensativeAnimationOnEndDraggingPage = true
        
        pagingFlowLayout.itemSize = CGSize(width: 140, height: 210)
        pagingFlowLayout.minimumLineSpacing = 5
        pagingFlowLayout.minimumInteritemSpacing = 5
        pagingFlowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: 210)), collectionViewLayout: pagingFlowLayout)
        
        collectionView.center = view.center
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.register(InstagramUserRecommendationCell.self, forCellWithReuseIdentifier: "InstagramUserRecommendationCell")
        collectionView.backgroundColor = UIColor(red: 250.0 / 255, green: 250.0 / 255, blue: 250.0 / 255, alpha: 1.0)
        
        view.addSubview(collectionView)
        view.backgroundColor = .white
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: UICollectionViewDataSource/Delegate
    
    private var numberOfItems = 10

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstagramUserRecommendationCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        numberOfItems -= 1
        collectionView.deleteItems(at: [indexPath])
    }
}

class InstagramUserRecommendationCell: UICollectionViewCell {
    
    var followButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor(red: 225.0 / 255, green: 225.0 / 255, blue: 225.0 / 255, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        
        followButton = UIButton(type: .custom)
        followButton.frame = CGRect(x: 11, y: 170, width: 116, height: 28)
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.layer.backgroundColor = UIColor(red: 30.0 / 255, green: 153.0 / 255, blue: 236.0 / 255, alpha: 1.0).cgColor
        followButton.layer.cornerRadius = 2.0
        contentView.addSubview(followButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

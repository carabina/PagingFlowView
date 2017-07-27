//
//  ViewController.swift
//  PagingFlowView
//
//  Created by xohozu on 07/27/2017.
//  Copyright (c) 2017 xohozu. All rights reserved.
//

import UIKit
import PagingFlowView

class ViewController: UIViewController, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pagingFlowLayout = PagingFlowLayout(pageLength: 145)
        pagingFlowLayout.itemSize = CGSize(width: 140, height: 210)
        pagingFlowLayout.minimumLineSpacing = 5
        pagingFlowLayout.minimumInteritemSpacing = 5
        pagingFlowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: view.bounds.height)), collectionViewLayout: pagingFlowLayout)
        collectionView.center = view.center
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: (view.bounds.width) / 2, bottom: 0, right: (view.bounds.width) / 2)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: (view.bounds.width - pagingFlowLayout.itemSize.width) / 2, bottom: 0, right: (view.bounds.width - pagingFlowLayout.itemSize.width) / 2)
        collectionView.register(PagingFlowCell.self, forCellWithReuseIdentifier: "PagingFlowCell")
        collectionView.backgroundColor = UIColor(red: 250.0 / 255, green: 250.0 / 255, blue: 250.0 / 255, alpha: 1.0)
        view.addSubview(collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PagingFlowCell", for: indexPath)
        return cell
    }
}

class PagingFlowCell: UICollectionViewCell {
    
    var followButton: UIButton!
    var nameLabel: UILabel!
    var referNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor(red: 225.0 / 255, green: 225.0 / 255, blue: 225.0 / 255, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        
        followButton = UIButton(type: .custom)
        followButton.frame = CGRect(x: 11, y: 170, width: 116, height: 28)
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        followButton.setTitle("关注", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.layer.backgroundColor = UIColor(red: 30.0 / 255, green: 153.0 / 255, blue: 236.0 / 255, alpha: 1.0).cgColor
        followButton.layer.cornerRadius = 2.0
        contentView.addSubview(followButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

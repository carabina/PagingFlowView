//
//  ViewController.swift
//  PagingFlowView
//
//  Created by xohozu on 07/27/2017.
//  Copyright (c) 2017 xohozu. All rights reserved.
//

import UIKit
import PagingFlowView

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView = UITableView(frame: view.bounds)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        view.addSubview(tableView)
    }
    
    // MARK: UITableViewDelegate/DataSource
    
    private let detailViewControllerClassList: [UIViewController.Type] = [InstagramViewController.self]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailViewControllerClassList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.textLabel?.text = "\(detailViewControllerClassList[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewControllerClass = detailViewControllerClassList[indexPath.row]
        
        navigationController?.pushViewController(viewControllerClass.init(), animated: true)
    }
}

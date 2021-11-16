//
//  MainView.swift
//  Moviegoer
//
//  Created by MacBook on 03.11.2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import Foundation
import UIKit
class MainView: UIView {
    
    lazy var table : UITableView = {
        let v = UITableView()
        v.rowHeight = 200
        v.separatorStyle = .singleLine
        v.tableFooterView = UIView()
        return v
    }()
    
    lazy var spinner : UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.color = .black
        return activityView
    }()
    
    func initialize() {
        table.register(MovieCell.self, forCellReuseIdentifier: MovieCell.cellId)
        addSubview(table)
        table.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        addSubview(spinner)
        spinner.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
}

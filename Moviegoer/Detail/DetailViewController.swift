//
//  DetailViewController.swift
//  Moviegoer
//
//  Created by кит on 02/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import UIKit
import CoreData


class DetailViewController: UIViewController {
    
    private var detailView = DetailView()
    private var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(movie.title ?? "Moviegoer")"
        self.navigationController?.navigationBar.tintColor = .black
        detailView.initialize(movie!)
    }
    
    override func loadView() {
        view = detailView
    }
    
    func showDetailMovie(_ movie: Movie?) {
        self.movie = movie
    }
    
}


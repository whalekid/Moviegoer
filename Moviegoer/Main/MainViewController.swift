//
//  MainViewController.swift
//  Moviegoer
//
//  Created by кит on 02/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

class MainViewController: UIViewController{
   
    private var viewModel = MovieViewModel()
    private var mainView = MainView()
    private var timer: Timer?
    private var mov: MovieEntity!
    private let searchController = UISearchController(searchResultsController: nil)
    fileprivate var page = 0
    fileprivate var isPaginationStopped = false
    fileprivate var searchPaginationText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setCDMovies()
        mainView.table.dataSource = self
        mainView.table.reloadData()
        setupSearch()
        mainView.table.delegate = self
        mainView.initialize()
    }

    override func loadView() {
        view = mainView
    }

    private func setupSearch() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Moviegoer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func showMovies() {
        timer?.invalidate()
        mainView.spinner.startAnimating()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {[unowned self] (_) in
            self.viewModel.fetchMoviesData(query: self.searchPaginationText, page: self.page) { [unowned self] in
                DispatchQueue.main.async {
                    self.mainView.table.dataSource = self
                    self.mainView.table.reloadData()
                    self.mainView.spinner.stopAnimating()
                    if self.viewModel.numberOfRowsInSection() % 20 != 0 {
                        self.isPaginationStopped = true
                    }
                }
            }
        })
    }
    
}


extension MainViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if isPaginationStopped == true {
            return
        }
        if (indexPath.row == viewModel.numberOfRowsInSection() - 1) {
            page += 1
            showMovies()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = mainView.table.dequeueReusableCell(withIdentifier: MovieCell.cellId, for: indexPath) as! MovieCell
        
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValuesOf(movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        let vc = DetailViewController()
        vc.showDetailMovie(movie)
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MainViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty{
            page = 1
            isPaginationStopped = false
            mainView.table.reloadData()
            searchPaginationText = searchText
            showMovies()
            
        }
        else {mainView.table.reloadData()}
    }
}
 

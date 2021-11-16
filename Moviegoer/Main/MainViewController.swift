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
        viewModel.setCoreDataMovies()
        mainView.table.dataSource = self
        mainView.table.reloadData()
        prepareSearch()
        mainView.table.delegate = self
        mainView.initialize()
    }

    override func loadView() {
        view = mainView
    }

    private func prepareSearch() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Moviegoer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func fetchMovies() {
        timer?.invalidate()
        if page == 1 {mainView.spinner.startAnimating()}
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {[unowned self] (_) in
            self.viewModel.fetchMoviesData(query: self.searchPaginationText, page: self.page) { [unowned self] (response) in
                DispatchQueue.main.async {
                    guard response == true else {
                        self.mainView.spinner.stopAnimating()
                        self.mainView.table.tableFooterView?.isHidden = true
                        let alert = UIAlertController(title: "Nothing found", message: "No results found for \(self.searchPaginationText), try another one", preferredStyle: .alert)
                                   alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil
                                   ))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    if self.page == 1 {
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.mainView.table.scrollToRow(at: indexPath, at: .top, animated: false)
                        self.mainView.table.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .fade)
                    }
                    self.mainView.spinner.stopAnimating()
                    self.mainView.table.tableFooterView?.isHidden = true
                    self.mainView.table.reloadData()
                    if self.viewModel.numberOfRowsInSection() % 20 != 0 {
                        self.isPaginationStopped = true
                    }
                }
            }
        })
    }
    
    private func activateBottomSpinner(tableView: UITableView, indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.section ==  0 && indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.color = .black
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            mainView.table.tableFooterView = spinner
            mainView.table.tableFooterView?.isHidden = false
        }
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
        if (indexPath.row == viewModel.numberOfRowsInSection() - 1 && searchPaginationText != "") {
            page += 1
            activateBottomSpinner(tableView: tableView, indexPath: indexPath)
            fetchMovies()
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
            searchPaginationText = searchText
            fetchMovies()
        }
        else {mainView.table.reloadData()}
    }
}
 

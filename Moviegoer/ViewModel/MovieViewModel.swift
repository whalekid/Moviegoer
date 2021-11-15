//
//  MovieViewModel.swift
//  Moviegoer
//
//  Created by кит on 02/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MovieViewModel {
    
    private var networkDataFetcher: MoviesNetworkFetcherProtocol = MoviesNetworkFetcher()
    private var networkService = NetworkService()
    private var coreDataProvider = CoreDataProvider()
    private var movies = [Movie]()
    
    func fetchMoviesData(query: String, page:Int, completion: @escaping () -> ()) {
        networkDataFetcher.fetchMovies(query: query, page: page) { [weak self] (result) in
            
            if let result = result {
                if page != 1 {
                    self?.movies += result.movies
                    completion()
                }
                else {
                    self?.movies = result.movies
                    self?.coreDataProvider.saveMovies(result.movies)
                    completion()
                }
            }
            else {
                print("Error processing json data")
                completion()
            }
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return movies.count
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Movie {
        return movies[indexPath.row]
    }
    
    func fetchPoster (movie: Movie, completion: @escaping (Data?) -> () ) {
        guard let posterString = movie.img else {return}
        if posterString != Constants.coreDataPosterURL {
            fetchImgData(posterString: posterString) { (data) in
                completion(data)
            }
        }
        else {
            coreDataProvider.fetchCoreDataPoster(movie: movie) {(data) in
                completion(data)
            }
        }
        
    }
    
    func setCDMovies() {
        coreDataProvider.setCoreDataMovies { (result) in
            switch result {
                
            case .success(let data):
                guard let coreDataMovies = data
                    else {
                        print ("Empty CoreData")
                        return
                }
                self.movies = coreDataMovies
                
            case .failure(let error as NSError):
                print ("error from fetching: \(error.userInfo)")
            }
        }
    }
    
    private func fetchImgData(posterString: String, completion: @escaping (Data?) -> ()) {
        networkService.getImageDataFrom(posterString: posterString) { (data) in
            if let fetchedData = data {
                completion(fetchedData)
            }
            else { completion(nil) }
        }
    }
    
}

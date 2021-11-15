//
//  CoreDataProvider.swift
//  Moviegoer
//
//  Created by кит on 14/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import UIKit
import CoreData

class CoreDataProvider{
    
    private lazy var context = CoreDataStack.shared.persistentContainer.viewContext
    private var networkService = NetworkService()
    
    func fetchCoreDataPoster( movie: Movie, completion: @escaping (Data?) -> ()) {
        guard let year = movie.year else {return}
        guard let title = movie.title else {return}
        guard let overview = movie.synopsis else {return}
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let yearKeyPredicate = NSPredicate(format: "year = %@", year)
        let overviewKeyPredicate = NSPredicate(format: "overview = %@", overview)
        let titleKeyPredicate = NSPredicate(format: "title = %@", title)
        let titleAndYearPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [yearKeyPredicate, titleKeyPredicate])
        let titleAndOverviewPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [overviewKeyPredicate, titleKeyPredicate])
        let orPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [titleAndYearPredicate, titleAndOverviewPredicate])
        fetchRequest.predicate = orPredicate
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                print ("Empty poster from CoreData")
                completion(nil)
            }
            else {
                results.forEach { (result) in
                    if let fetchedData = result.poster {
                        completion(fetchedData)
                    }
                    else {
                        print ("Error of Fetching poster from CoreData")
                        completion(nil)
                    }
                }
            }
        }
        catch let error as NSError{
            print(error.userInfo)
        }
    }
    
    func setCoreDataMovies(completion: @escaping (Result<[Movie]?,Error>) -> ()) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        var movies = [Movie]()
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                completion(.success(nil))
            }
            else {
                results.forEach { (result) in
                    let movie = Movie(title: result.title, year: result.year, rating: result.rating, img: Constants.coreDataPosterURL, synopsis: result.overview)
                    movies.append(movie)
                }
                completion(.success(movies))
            }
        }
        catch let error as NSError{
            completion(.failure(error))
        }
    }
    
    func saveMovies(_ movies: [Movie]){
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                updateContext(movies: movies)
            }
            else {
                results.forEach({ (movie) in
                    context.delete(movie)
                })
                updateContext(movies: movies)
            }
        }
        catch let error as NSError{
            print(error.userInfo)
        }
    }
    
    private func updateContext(movies: [Movie]) {
        movies.forEach({ (movie) in
            guard let posterString = movie.img else {return}
            fetchImgData(posterString: posterString) {
                (data) in
                self.context.perform {
                    let mov = MovieEntity(context: self.context)
                    mov.title = movie.title
                    mov.overview = movie.synopsis
                    mov.year = movie.year
                    mov.rating = movie.rating ?? 0.0
                    mov.poster = data
                    try! self.context.save()
                }
            }
        })
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

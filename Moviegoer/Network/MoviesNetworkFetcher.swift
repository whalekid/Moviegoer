//
//  NetworkDataFetcher.swift
//  Moviegoer
//
//  Created by кит on 03/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import UIKit

protocol MoviesNetworkFetcherProtocol {
    func fetchNetworkMovies(query: String, page:Int, response: @escaping (MoviesData?) -> Void)
}

class MoviesNetworkFetcher: MoviesNetworkFetcherProtocol {
    private var networkService = NetworkService()
   
    func fetchNetworkMovies(query: String, page:Int, response: @escaping (MoviesData?) -> Void) {
        guard let moviesURL = URLBuilder().build(query: query, page: page) else {return}
        networkService.fetchNetworkData(moviesURL: moviesURL) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(MoviesData.self, from: data)
                    
                    DispatchQueue.main.async {
                        response(jsonData)
                    }
                } catch let JSONerror {
                    print ("error from JSONserialization: \(JSONerror.localizedDescription)")
                    response(nil)
                }
            case .failure(let error):
                print ("error from fetching: \(error.localizedDescription)")
                response(nil)
            }
            
        }
    }
}

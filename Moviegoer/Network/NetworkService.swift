//
//  NetworkService.swift
//  Moviegoer
//
//  Created by кит on 02/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.

import Foundation

class NetworkService {
    
    private var dataTask: URLSessionDataTask?
    
    func fetchNetworkData(moviesURL: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: moviesURL) else {return}
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.emptyResponseError))
                return
            }
            print("Response status code: \(response.statusCode)")

            guard let data = data else {
                completion(.failure(NetworkError.emptyDataError))
                return
            }

            completion(.success(data))
        }
        dataTask?.resume()
    }
    
    // MARK: - Get image data
     func getImageDataFrom(posterString: String, completion: @escaping (Data?) -> Void)  {
        
        let urlString = URLBuilder().buildImgUrl(posterString: posterString)
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Empty Data")
                completion(nil)
                return
            }
            completion(data)
        }
        dataTask?.resume()
    }
}






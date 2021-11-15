//
//  Movie.swift
//  Moviegoer
//
//  Created by кит on 02/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import UIKit

struct MoviesData: Decodable {
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie: Decodable {
    
    let title: String?
    let year: String?
    let rating: Double?
    let img: String?
    let synopsis: String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case synopsis = "overview"
        case year = "release_date"
        case rating = "vote_average"
        case img = "poster_path"
    }
}

//
//  URLBuilder.swift
//  Moviegoer
//
//  Created by кит on 03/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import Foundation
import UIKit
struct URLBuilder {
    
    private let path = URLComponents(string: "https://api.themoviedb.org/3/search/movie")
    private let apiKey = "14fc346c6005b8c4df02936fcfbfd9f4"
    
    func build(query: String, page: Int) -> String? {
        var urlComp = path
        urlComp?.queryItems = [
            .init(name: "api_key", value: apiKey),
            .init(name: "language", value: "en-US"),
            .init(name: "query", value: query),
            .init(name: "page", value: String(page))
        ]
        guard let url = urlComp?.string else {return nil}
        return url
    }
    
    func buildImgUrl(posterString: String) -> String {
        return "https://image.tmdb.org/t/p/w300" + posterString
    }
    
}

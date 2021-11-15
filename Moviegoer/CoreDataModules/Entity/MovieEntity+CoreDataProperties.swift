//
//  MovieEntity+CoreDataProperties.swift
//  
//
//  Created by кит on 12/11/2021.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var year: String?
    @NSManaged public var overview: String?
    @NSManaged public var rating: Double
    @NSManaged public var poster: Data?

}

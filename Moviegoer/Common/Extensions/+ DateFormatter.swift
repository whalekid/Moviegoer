//
//  + DateFormatter.swift
//  Moviegoer
//
//  Created by кит on 03/11/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//

import Foundation
extension DateFormatter {
    func convertDateFormater(_ date: String?) -> String {
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let originalDate = date {
            if let newDate = dateFormatter.date(from: originalDate) {
                dateFormatter.dateFormat = "yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }

}

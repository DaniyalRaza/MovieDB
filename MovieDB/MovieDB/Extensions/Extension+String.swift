//
//  Extension+String.swift
//  MovieDB
//
//  Created by Invision on 26/11/2017.
//  Copyright © 2017 Daniyal Raza. All rights reserved.
//

import Foundation

extension String {
    
    /**
     It converts a string to Date object
     
     The input parameter should be in the yyyy-MM-dd format.
     
     - parameter date: represents the string to convert.
     
     -returns: An object of type Date.
     */
    
    func toDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    /**
     This property returns a date in short format
     
     -returns: A string in MMM yyyy format.
     */
    
    var shortDate: String? {
        guard let date = toDate(date: self) else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: date)
    }
}

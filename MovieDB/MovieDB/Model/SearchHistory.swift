//
//  SearchHistory.swift
//  MovieDB
//
//  Created by Invision on 25/11/2017.
//  Copyright © 2017 Daniyal Raza. All rights reserved.
//

import Foundation

class SearchHistory {
    
    static private let suggestionsKey = "suggestions"
    
    /**
     This property returns suggestions based on previous search history
     
     Fetches suggestions from User Defaults
     
     -returns: An array of string.
     */
    static var suggestions: [String] {
        guard let suggestions = UserDefaults.standard.array(forKey: suggestionsKey) as? [String] else {
            return []
        }
        return suggestions
    }
    
    /**
     Adds the query in suggestions record
     
     Adds a query if doesn't exist. Limits the suggestion to 10 items.
     
     - parameter query: Query to save in suggestions.
     */
    
    static func addSuggestion(query:String?) {
        var _suggestions = suggestions
        if query == nil || _suggestions.contains(query!){
            return
        }
        if _suggestions.count == 10 {
            _suggestions.removeLast()
        }
        _suggestions.insert(query!, at: 0)
        UserDefaults.standard.setValue(_suggestions, forKey: suggestionsKey)
    }
}

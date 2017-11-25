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
    
    static var suggestions: [String] {
        guard let suggestions = UserDefaults.standard.array(forKey: suggestionsKey) as? [String] else {
            return []
        }
        return suggestions
    }
    
    static func addSuggestion(query:String, shouldAdd:Bool) {
        if !shouldAdd { return }
        
        var _suggestions = suggestions
        if _suggestions.contains(query) {
            return
        }
        if _suggestions.count == 10 {
            _suggestions.removeLast()
        }
        _suggestions.insert(query, at: 0)
        UserDefaults.standard.setValue(_suggestions, forKey: suggestionsKey)
    }
}

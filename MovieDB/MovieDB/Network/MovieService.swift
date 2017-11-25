//
//  MovieService.swift
//  MovieDB
//
//  Created by Invision on 25/11/2017.
//  Copyright © 2017 Daniyal Raza. All rights reserved.
//

import Foundation
import Moya

enum MovieService {
    case showMovies(page:Int)
    case searchMovies(query: String, page: Int)
}

extension MovieService: TargetType {
    
    var baseURL: URL { return URL(string: "http://api.themoviedb.org/3?api_key=2696829a81b1b5827d515ff121700838")! }
    
    var path: String {
        switch self {
        case .showMovies:
            return "/discover/movie"
        case .searchMovies:
            return "/search/movie"
        }
    }
        
    var method: Moya.Method {
        switch self {
        case .searchMovies, .showMovies:
            return .get
        }
    }
        
    var task: Task {
        switch self {
        case .showMovies(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case let .searchMovies(query, page):
            return .requestParameters(parameters: ["query": query, "page": page], encoding: URLEncoding.queryString)
        }
    }
 
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}

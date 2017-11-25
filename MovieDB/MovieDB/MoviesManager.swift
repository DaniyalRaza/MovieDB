//
//  MoviesManager.swift
//  MovieDB
//
//  Created by Invision on 25/11/2017.
//  Copyright © 2017 Daniyal Raza. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

protocol MoviesDelegate : class {
    func moviesFetched()
}

class MoviesManager: NSObject {

    static let shared = MoviesManager()
    
    weak var delegate:MoviesDelegate?
    
    let moviesProvider = MoyaProvider<MovieService>()
    
    var movies:[Movie] = []
    
    var isLoadingData = false
    var currentPage = 1
    
    var previousQuery:String?{
        didSet{
            currentPage = 1
            movies.removeAll()
        }
    }
    
    var currentQuery: String?{
        didSet{
            if currentQuery != previousQuery{
                previousQuery = currentQuery
            }
            else{
                currentPage += 1
            }
            updateResults()
        }
    }
    
    func updateResults(){
        if isLoadingData{ return }
        if currentQuery == nil || currentQuery!.isEmpty{
            showMovies()
        }
        else{
            searchMovies(query: currentQuery!, page: currentPage)
        }
        self.isLoadingData = true
    }
    
    
    func searchMovies(query:String, page:Int){
        moviesProvider.request(.searchMovies(query: query, page: page)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let jsonDictionary = JSON(data: data).dictionaryValue
                
                if let results = jsonDictionary["results"]?.array{
                    self.movies.append(contentsOf: results.map{ Movie(json: $0) })
                    self.delegate?.moviesFetched()
                    SearchHistory.addSuggestion(query: query, shouldAdd: results.count > 0)
                }
            case let .failure(error):
                print(error)
            }
            self.isLoadingData = false
        }
    }
    
    func showMovies(){
        moviesProvider.request(.showMovies(page: currentPage)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let jsonDictionary = JSON(data: data).dictionaryValue
                
                if let results = jsonDictionary["results"]?.array{
                    self.movies.append(contentsOf: results.map{ Movie(json: $0) })
                    self.delegate?.moviesFetched()
                }
            case let .failure(error):
                print(error)
            }
            self.isLoadingData = false
        }
    }
    
}

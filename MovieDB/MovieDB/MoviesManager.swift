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
    
    var currentQuery: String?{
        didSet{
            updateResults(query: currentQuery)
        }
    }
    
    func updateResults(query:String? = nil){
        if query == nil || query!.isEmpty{
            showMovies()
        }
        else{
            if !isLoadingData{
                currentPage+=1
                isLoadingData = true
                searchMovies(query: query!, page: currentPage)
            }
        }
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
        moviesProvider.request(.showMovies) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let jsonDictionary = JSON(data: data).dictionaryValue
                
                if let results = jsonDictionary["results"]?.array{
                    self.movies = results.map{ Movie(json: $0) }
                    self.delegate?.moviesFetched()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
}

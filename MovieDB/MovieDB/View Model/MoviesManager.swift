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
    func movieFetchFailed(message:String)
}

class MoviesManager: NSObject {

    //Singleton instance
    static let shared = MoviesManager()
    
    weak var delegate:MoviesDelegate?
    
    //Movie service provider
    let moviesProvider = MoyaProvider<MovieService>()
    
    var movies:[Movie] = []
    
    var isLoadingData = false
    var currentPage = 1
    
    /**
     The previous query when set resets the page counter to 1 and clears movie records.
     */
    var previousQuery:String?{
        didSet{
            currentPage = 1
            movies.removeAll()
        }
    }
    
    /**
     The current query when set increments the page counter and updates movie record.
     */
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
    
    /**
     Initiates movies search and fetches top movies when no query provided
     */
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
    
    /**
     Searches movie in database and poulates the movies array. Notifies the delegate on success or failure
     
     - parameter query: The query to search in database.
     - parameter page: The page number to fetch from.

     */
    func searchMovies(query:String, page:Int){
        moviesProvider.request(.searchMovies(query: query, page: page)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let jsonDictionary = JSON(data: data).dictionaryValue
                
                if let results = jsonDictionary["results"]?.array, results.count > 0{
                    self.movies.append(contentsOf: results.map{ Movie(json: $0) })
                    self.delegate?.moviesFetched()
                    SearchHistory.addSuggestion(query: query)
                }
                else{
                    print("No movies to show")
                }
            case let .failure(error):
                self.delegate?.movieFetchFailed(message: error.localizedDescription)
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
                self.delegate?.movieFetchFailed(message: error.localizedDescription)
            }
            self.isLoadingData = false
        }
    }
    
}

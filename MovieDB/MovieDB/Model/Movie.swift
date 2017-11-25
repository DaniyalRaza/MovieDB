//
//  Movie.swift
//
//  Created by Daniyal Raza on 25/11/2017
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Movie {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let posterPath = "poster_path"
    static let backdropPath = "backdrop_path"
    static let voteCount = "vote_count"
    static let overview = "overview"
    static let originalTitle = "original_title"
    static let voteAverage = "vote_average"
    static let popularity = "popularity"
    static let id = "id"
    static let originalLanguage = "original_language"
    static let releaseDate = "release_date"
    static let video = "video"
    static let title = "title"
    static let adult = "adult"
  }

  // MARK: Properties
  public var posterPath: String?
  public var backdropPath: String?
  public var voteCount: Int?
  public var overview: String?
  public var originalTitle: String?
  public var voteAverage: Float?
  public var popularity: Float?
  public var id: Int?
  public var originalLanguage: String?
  public var releaseDate: String?
  public var video: Bool? = false
  public var title: String?
  public var adult: Bool? = false

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public init(json: JSON) {
    posterPath = json[SerializationKeys.posterPath].string
    backdropPath = json[SerializationKeys.backdropPath].string
    voteCount = json[SerializationKeys.voteCount].int
    overview = json[SerializationKeys.overview].string
    originalTitle = json[SerializationKeys.originalTitle].string
    voteAverage = json[SerializationKeys.voteAverage].float
    popularity = json[SerializationKeys.popularity].float
    id = json[SerializationKeys.id].int
    originalLanguage = json[SerializationKeys.originalLanguage].string
    releaseDate = json[SerializationKeys.releaseDate].string
    video = json[SerializationKeys.video].boolValue
    title = json[SerializationKeys.title].string
    adult = json[SerializationKeys.adult].boolValue
  }

}

extension Movie{
    
    
    /**
     This property returns a URL to fetch movie poster
     */
    
    var posterURL:URL?{
        if posterPath == nil {return nil}
        return URL(string: "http://image.tmdb.org/t/p/w92\(posterPath!)")
    }
    
}

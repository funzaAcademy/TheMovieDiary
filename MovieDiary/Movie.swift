//
//  Movie.swift
//  MovieDiary
//
//  A Movie Entity As Defined By TMDB
//
//  Created by Sanjay Noronha on 2016/03/27.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import Foundation

struct Movie {
    
    // MARK: Properties
    
    let title: String
    let id: Int
    let posterPath: String?
    let releaseYear: String?
    
    // MARK:- Initializers
    init(dictionary: [String:AnyObject]) {
        
        title = dictionary[MovieDiaryConstants.JSONResponseKeys.MovieTitle] as! String
        id = dictionary[MovieDiaryConstants.JSONResponseKeys.MovieID] as! Int
        posterPath = dictionary[MovieDiaryConstants.JSONResponseKeys.MoviePosterPath] as? String
        
        if let releaseDateString = dictionary[MovieDiaryConstants.JSONResponseKeys.MovieReleaseDate] as? String where releaseDateString.isEmpty == false {
            releaseYear = releaseDateString.substringToIndex(releaseDateString.startIndex.advancedBy(4))
        } else {
            releaseYear = ""
        }
    }
    
    // MARK: Static_Functions
    static func moviesFromResults(results: [[String:AnyObject]]) -> [Movie] {
        
        var movies = [Movie]()
                
        for result in results {
            movies.append(Movie(dictionary: result))
        }
        
        return movies
    }
}

    // MARK: Movie_Extension
    extension Movie: Equatable {}

    // MARK: Equatable
    func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }

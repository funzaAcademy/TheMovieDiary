//
//  MovieDiaryConstants.swift
//  MovieDiary
//
// List of Constants Values Used Across The Projet
// TMDB API Reference : http://docs.themoviedb.apiary.io/#
// TMDB Sessions : https://www.themoviedb.org/documentation/api/sessions
//
//  Created by Sanjay Noronha on 2016/03/25.
//  Copyright © 2016 funza Academy. All rights reserved.
//

import UIKit

struct  MovieDiaryConstants
{

    
    static let AppThemeColor = UIColor(red: 32.0/225, green: 148.0/225, blue: 250/225, alpha: 1)
    
    struct ErrorCodes {
        
        static let tmdbAPI = -100
    }
    
    struct Constants {

        static let ApiKey : String = "4e8bdccc3bb63cefbec21f936eca5651"
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
        static let AuthorizationURL : String = "https://www.themoviedb.org/authenticate/"
    }
    
    struct Methods {

        //Account
        static let Account = "/account"
        static let AccountIDFavoriteMovies = "/account/{id}/favorite/movies"
        static let AccountIDFavorite = "/account/{id}/favorite"
        static let AccountIDWatchlistMovies = "/account/{id}/watchlist/movies"
        static let AccountIDWatchlist = "/account/{id}/watchlist"
        
        //Authentication
        static let AuthenticationTokenNew = "/authentication/token/new"
        static let AuthenticationSessionNew = "/authentication/session/new"
        
        //Search
        static let SearchMovie = "/search/movie"
        
        //Config
        //static let Config = "/configuration"
        
    }
    
    struct URLKeys {
        static let UserID = "id"
    }
    
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query" //used in searching for movies
    }
    
    struct JSONBodyKeys {
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
    }
    
    struct JSONResponseKeys {
        
        //General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        //Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        //Account
        static let UserID = "id"
        
        //Movies
        //http://docs.themoviedb.apiary.io/#reference/search/searchmovie/get
        static let MovieID = "id"
        static let MovieTitle = "title"
        static let MoviePosterPath = "poster_path" //path to image
        static let MovieReleaseDate = "release_date"
        static let MovieReleaseYear = "release_year"
        static let MovieResults = "results"
        
    }
    
    
}


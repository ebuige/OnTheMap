//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by Troutslayer33 on 6/23/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//

import Foundation
extension OTMClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: API Key and Application ID for parse
        static let ApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: URLs
        static let ParseURLSecure : String = "https://api.parse.com/1/classes/StudentLocation"
        static let UdacityURLSecure : String = "https://www.udacity.com/api/"
        
        // MARK: PIN
        static let reuseId = "pin"
        
    }
    
    // MARK: - Methods
    struct Methods {
        
        static let Session = "session"
        static let Users = "users/"
        
    }
    
    // MARK: - URL Keys
    struct URLKeys {
        
        static let UserID = "user_id"
        
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
        
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
        
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        // MARK: Account
        static let UserID = "id"
        
        // MARK: Config
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        static let ConfigImages = "images"
        static let ConfigPosterSizes = "poster_sizes"
        static let ConfigProfileSizes = "profile_sizes"
        
        // MARK: Movies
        static let MovieID = "id"
        static let MovieTitle = "title"
        static let MoviePosterPath = "poster_path"
        static let MovieReleaseDate = "release_date"
        static let MovieReleaseYear = "release_year"
        static let MovieResults = "results"
        
    }
    
    }
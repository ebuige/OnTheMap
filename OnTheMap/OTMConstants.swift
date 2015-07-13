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
    
}
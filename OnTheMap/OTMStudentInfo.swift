//
//  OTMStudentInfo.swift
//  OnTheMap
//
//  Created by Troutslayer33 on 6/23/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//

import Foundation

class StudentInfo: NSObject {
    
    let latitude: Double
    let longitude: Double
    let name: String
    var info: String
    
    init(latitude: Double, longitude: Double, name: String, info: String) {
        
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.info = info
        
    }
    
    init(data: [String: AnyObject]) {
        
        var firstName = data["firstName"] as! String
        var lastName = data["lastName"] as! String
        
        self.name = "\(firstName) \(lastName)"
        self.latitude = data["latitude"] as! Double
        self.longitude = data["longitude"] as! Double
        self.info = data["mediaURL"] as! String
        
    }
    
}

struct OTMStudentInfo {
    
    var title = ""
    var id = 0
    var posterPath: String? = nil
    var releaseYear: String? = nil
    
    /* Construct a TMDBMovie from a dictionary */
    init(dictionary: [String : AnyObject]) {
        
        title = dictionary[OTMClient.JSONResponseKeys.MovieTitle] as! String
        id = dictionary[OTMClient.JSONResponseKeys.MovieID] as! Int
        posterPath = dictionary[OTMClient.JSONResponseKeys.MoviePosterPath] as? String
        
        if let releaseDateString = dictionary[OTMClient.JSONResponseKeys.MovieReleaseDate] as? String {
            
            if releaseDateString.isEmpty == false {
                releaseYear = releaseDateString.substringToIndex(advance(releaseDateString.startIndex, 4))
            } else {
                releaseYear = ""
            }
        }
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of TMDBMovie objects */
    static func moviesFromResults(results: [[String : AnyObject]]) -> [OTMStudentInfo] {
        var movies = [OTMStudentInfo]()
        
        for result in results {
            movies.append(OTMStudentInfo(dictionary: result))
        }
        
        return movies
    }
}


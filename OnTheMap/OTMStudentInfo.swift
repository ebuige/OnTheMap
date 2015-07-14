//
//  OTMStudentInfo.swift
//  OnTheMap
//
//  Created by Troutslayer33 on 6/23/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//

import Foundation

struct StudentInfo {
    
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



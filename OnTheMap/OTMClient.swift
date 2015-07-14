//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Troutslayer33 on 6/23/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//

import Foundation
class OTMClient : NSObject {
    
    static let sharedInstance = OTMClient()
    
    /* Shared session */
    var session: NSURLSession
    
   /* Variables */
    var username: String?
    var password: String?
    var studentInfo: [[String: AnyObject]]?
    var objectId: String?
    var uniqueKey: String?
    var firstName: String? { didSet{ OTMClient.sharedInstance.firstName = firstName! } }
    var lastName: String? { didSet{ OTMClient.sharedInstance.lastName = lastName! } }
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var sessionId: String?
    var userId: String? { didSet{ OTMClient.sharedInstance.uniqueKey = userId! } }
    
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: POST FOR UDACITY LOGIN
    
    func taskForPostMethod(completionHandler: (success: Bool, res: Int?, error: NSError?) -> Void) {
        let urlString = OTMClient.Constants.UdacityURLSecure + OTMClient.Methods.Session
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(self.username!)\", \"password\": \"\(self.password!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) { data, response, postError in
            
            if postError != nil {
                
                completionHandler(success: false, res: nil, error: postError)
                
            } else {

            if let res = response as? NSHTTPURLResponse {

                if res.statusCode != 200 {
                    completionHandler(success: false, res: res.statusCode, error: postError)

                } else {
                        
                        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                        var error: NSError?
                        if let parsedData = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
                            
                            if let account = parsedData["account"] as? NSDictionary {
                                
                                let key = account["key"] as! String
                                
                                self.userId = key
                            }
                            
                            if let session = parsedData["session"] as? NSDictionary {
                                
                                let id = session["id"] as! String
                                self.sessionId = id
                                
                            }
                            
                            completionHandler(success: true, res: nil, error: nil)
                            
                        }
                        
                    } //end of parsed logic
                    
                } //end of post error
                
            } // end of status code check
        
        }  // end of task
        task.resume()
        
    }
    
    // MARK: - task to get user info
    
    func taskForGETMethod(completionHandler: (success: Bool, res: Int?, error: NSError?) -> Void) {
        let urlString = OTMClient.Constants.UdacityURLSecure + OTMClient.Methods.Users + userId!
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        let task = session.dataTaskWithRequest(request) { data, response, downloadingError in
            
            if let res = response as? NSHTTPURLResponse {
                
                if res.statusCode != 200 {
                    
                    completionHandler(success: false, res: res.statusCode, error: downloadingError)
                }
                
            }
            
            if downloadingError != nil {
                
                completionHandler(success: false, res: nil, error: downloadingError)
                
            } else {
                
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                var error: NSError?
                if let parsedData = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
                    
                    if let userInfo = parsedData["user"] as? NSDictionary {
                        
                        let firstName = userInfo["first_name"] as! String
                        self.firstName = firstName
                        
                        let lastName = userInfo["last_name"] as! String
                        self.lastName = lastName
                        
                    }
                    
                    completionHandler(success: true, res: nil, error: nil)
                    
                }
                
            }
            
        }
        
        task.resume()
        
    }
    



    // MARK - Task for get method student info limit

    func taskForGetMethod(limit: Int, completionHandler: (success: Bool, res: Int?, error: NSError?) -> Void) {
        
        var dataArray: [[String : AnyObject]]?
        let urlString = OTMClient.Constants.ParseURLSecure + "?limit=\(limit)"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = session.dataTaskWithRequest(request) { data, response, downloadingError in
            
            if let res = response as? NSHTTPURLResponse {
                
                if res.statusCode != 200 {
                    
                    completionHandler(success: false, res: res.statusCode, error: downloadingError)
                    
                }
                
            }
            
            if downloadingError != nil {
                
                completionHandler(success: false, res: nil, error: downloadingError)
                
            } else {
                
                var error: NSError?
                if let parsedData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
                    if let studentData = parsedData["results"] as? [[String : AnyObject]] {
                        self.studentInfo = studentData
                        
                    }
                    
                }
                
                completionHandler(success: true, res: nil, error: nil)
                
            }
            
        }
        
        task.resume()
        
    }

    // MARK: - Post Student Location
    
    func taskForPostLinkMethod(completionHandler: (success: Bool, res: Int?, error: NSError?) -> Void) {
        
        let urlString = OTMClient.Constants.ParseURLSecure
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(self.uniqueKey!)\", \"firstName\": \"\(self.firstName!)\", \"lastName\": \"\(self.lastName!)\",\"mapString\": \"\(self.mapString!)\", \"mediaURL\": \"\(self.mediaURL!)\",\"latitude\": \(self.latitude!), \"longitude\": \(self.longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request) { data, response, downloadingError in
            
            if let res = response as? NSHTTPURLResponse {
                if res.statusCode != 200 {
                    
                    completionHandler(success: false, res: res.statusCode, error: nil)
                    
                }
                
            }
            
            if downloadingError != nil {
                
                completionHandler(success: false, res: nil, error: downloadingError)
                
            } else {
                
                var error: NSError?
                if let parsedData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
                    
                    if let objectId = parsedData["objectId"] as? String {
                        
                        self.objectId = objectId
                        
                    }
                    
                }
                
                completionHandler(success: true, res: nil, error: nil)
                
            }
            
        }
        
        task.resume()
        
    }

    
    // MARK: - Logout
    
    func taskForDeleteMethod(completionHandler: (success: Bool, res: Int?, error: NSError?) -> Void) {
        
        let urlString = OTMClient.Constants.UdacityURLSecure + OTMClient.Methods.Session
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, res: nil, error: error)
            }
            completionHandler(success: true, res: nil, error: error)
        }
        task.resume()
        
    }

        
}
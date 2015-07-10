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
    var objectId: String?
    var studentInfo: [[String: AnyObject]]?
    var uniqueKey: String?
//    var firstName: String?
//    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var userId: String? { didSet{ OTMClient.sharedInstance.uniqueKey = userId! } }
    var sessionId: String?
    var firstName: String? { didSet{ OTMClient.sharedInstance.firstName = firstName! } }
    var lastName: String? { didSet{ OTMClient.sharedInstance.lastName = lastName! } }
    
    /* Authentication state */
 //   var sessionID : String? = nil
//    var userID : String? = nil
    
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
            
            if let res = response as? NSHTTPURLResponse {
                
                println("result = \(res.statusCode)")
                
                if res.statusCode != 200 {
                    
                    println("set success false")
                    
                    completionHandler(success: false, res: res.statusCode, error: postError)
                    
                    println("after completion handler")
                    
                } else {
    
            

            if postError != nil {
                
                println("downloadingError not nil")
                
                completionHandler(success: false, res: nil, error: postError)
                
                } else {
                
                println("postError = \(postError)")
                
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                var error: NSError?
                if let parsedData = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
                    
                    if let account = parsedData["account"] as? NSDictionary {
                        
                        let key = account["key"] as! String
                        
                        self.userId = key
                        println("user id after set = \(self.userId)")
                    }
                    
                    if let session = parsedData["session"] as? NSDictionary {
                        
                        let id = session["id"] as! String
                        self.sessionId = id
                        
                    }
                    
                    completionHandler(success: true, res: nil, error: nil)
                    
                }
                
            }
            
        }
        
        }
        }
        task.resume()
        
    }
    
    // MARK: - task to get user info
    
    func taskForGETMethod(completionHandler: (success: Bool, res: Int?, error: NSError?) -> Void) {
        println("user id = \(self.userId)")
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

    
    // MARK: - GET
    
    
        
    // MARK: - POST
    
        
    /* Use this unFavoriteButtonTouchUpInside as a reference if you need it 😄 */
    
    //    func unFavoriteButtonTouchUpInside(sender: AnyObject) {
    //
    //        /* TASK: Remove movie as favorite, then update favorite buttons */
    //
    //        /* 1. Set the parameters */
    //        let methodParameters = [
    //            "api_key": appDelegate.apiKey,
    //            "session_id": appDelegate.sessionID!
    //        ]
    //
    //        /* 2. Build the URL */
    //        let urlString = appDelegate.baseURLSecureString + "account/\(appDelegate.userID!)/favorite" + appDelegate.escapedParameters(methodParameters)
    //        let url = NSURL(string: urlString)!
    //
    //        /* 3. Configure the request */
    //        let request = NSMutableURLRequest(URL: url)
    //        request.HTTPMethod = "POST"
    //        request.addValue("application/json", forHTTPHeaderField: "Accept")
    //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //        request.HTTPBody = "{\"media_type\": \"movie\",\"media_id\": \(self.movie!.id),\"favorite\":false}".dataUsingEncoding(NSUTF8StringEncoding)
    //
    //        /* 4. Make the request */
    //        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
    //
    //            if let error = downloadError? {
    //                println("Could not complete the request \(error)")
    //            } else {
    //
    //                /* 5. Parse the data */
    //                var parsingError: NSError? = nil
    //                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as NSDictionary
    //
    //                /* 6. Use the data! */
    //                if let status_code = parsedResult["status_code"] as? Int {
    //                    if status_code == 13 {
    //                        dispatch_async(dispatch_get_main_queue()) {
    //                            self.unFavoriteButton.hidden = true
    //                            self.favoriteButton.hidden = false
    //                        }
    //                    }
    //                } else {
    //                    println("Could not find status_code in \(parsedResult)")
    //                }
    //            }
    //        }
    //
    //        /* 7. Start the request */
    //        task.resume()
    //    }
    
    // MARK: - Helpers
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given a response with error, see if a status_message is returned, otherwise return the previous error */
    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
        
        if let parsedResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject] {
            
            if let errorMessage = parsedResult[OTMClient.JSONResponseKeys.StatusMessage] as? String {
                
                let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                
                return NSError(domain: "TMDB Error", code: 1, userInfo: userInfo)
            }
        }
        
        return error
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    // MARK: - Shared Instance
    
//    class func sharedInstance() -> OTMClient {
        
//        struct Singleton {
//            static var sharedInstance = OTMClient()
//        }
//
//        return Singleton.sharedInstance
//    }
}
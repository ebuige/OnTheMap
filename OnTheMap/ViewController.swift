//
//  ViewController.swift
//  OnTheMap
//
//  Created by Troutslayer33 on 6/15/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    var tapRecognizer: UITapGestureRecognizer? = nil
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure tap recognizer */
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        self.tapRecognizer?.numberOfTapsRequired = 1
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }
    
    // MARK: - Actions
    
    @IBAction func login(sender: AnyObject) {
        
        OTMClient.sharedInstance.username = username.text
        OTMClient.sharedInstance.password = password.text
        getSessionID()
            /*1. set the parameter */
            
            /* 2. Build the URL */
  //          let urlString = OTMClient.Constants.UdacityURLSecure + OTMClient.Methods.Session
//            let url = NSURL(string: urlString)!
//        println("username = \(self.username.text) password = \(self.password.text)")
            
            /* 3. Configure the request */
  //          let request = NSMutableURLRequest(URL: url)
//            request.HTTPMethod = "POST"
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//         request.HTTPBody = "{\"udacity\": {\"username\": \"\(self.username.text)\", \"password\": \"\(self.password.text)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
         //   request.HTTPBody = "{\"udacity\": {\"username\": \"eb4635@att.com\", \"password\": \"2020$K1ll5!\"}}".dataUsingEncoding(NSUTF8StringEncoding)
//            let session = NSURLSession.sharedSession()
        
 //       println("body = \(request.HTTPBody)")
        
            
            
            /* 4. Make the request */
//            let task = session.dataTaskWithRequest(request) { data, response, error in
                
//                if error != nil { // Handle error…
//                    println("Error connecting to Udacity")
//                }
                
                /* 5. Parse the data */
//                var parsingError: NSError? = nil
//                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
//                println(NSString(data: newData, encoding: NSUTF8StringEncoding))
                
//                var parsedResponse = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: nil) as! [String:AnyObject]
                
 //               println("Response: \(parsedResponse)")
   //             self.completeLogin()
 //           }
 //           task.resume()
            
        }
    
    func getSessionID() {
        
        OTMClient.sharedInstance.taskForPostMethod() { (success: Bool, res: Int?, error: NSError?) -> Void in
            
            if success {
                self.completeLogin()
            } else {
                self.displayError(error)
            }
        }
        
    }

    func completeLogin() {
        
        OTMClient.sharedInstance.taskForGETMethod() { (success: Bool, res: Int?, error: NSError?) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    //         self.debugTextLabel.text = ""
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OntheMapTabBarController") as! UITabBarController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
                
            } else {
                self.displayError(error)
            }
        }

       }

    func displayError(error: NSError?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = error {
//self.debugTextLabel.text = errorString
            }
        })
    }

    
    // MARK: - Keyboard Fixes
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }


}

extension ViewController {
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}

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
        
        var loginData = (username.text.isEmpty, password.text.isEmpty)
        switch loginData {
            
        case (true, true):
            self.displayAlertView("You have to enter username and password to log in")
        case (true, false):
            self.displayAlertView("You have to enter username to log in")
        case (false, true):
            self.displayAlertView("You have to enter password to log in")
        case (false, false):
            OTMClient.sharedInstance.username = username.text
            OTMClient.sharedInstance.password = password.text
            getSessionID()

        default:
            break
            
        }

    }
    
    func getSessionID() {
        
        OTMClient.sharedInstance.taskForPostMethod() { (success: Bool, res: Int?, error: NSError?) -> Void in
            
            if success {
                self.completeLogin()
            } else {
                self.displayError(success, res: res, error:error)
            }
        }
        
    }

    func completeLogin() {
        
        OTMClient.sharedInstance.taskForGETMethod() { (success: Bool, res: Int?, error: NSError?) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OntheMapTabBarController") as! UITabBarController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
                
            } else {
                self.displayError(success, res: res, error:error)
            }
        }

       }

      
    func displayError(success: Bool, res: Int?, error: NSError?) {
        
        if res != nil {
            
            self.statusCodeCheck(res!)
            
        } else {
            
            self.displayAlertView("Networking Error")
            
        }
        
    }
   
    // MARK: Check status code
    
    func statusCodeCheck(statusCode: Int) {
        
        switch statusCode {
            
        case 403:
            self.displayAlertView("Either username(email) or password is not correct")
        case 401:
            self.displayAlertView("Access to this resource is restricted")
        default:
            break
            
        }
        
    }

    // MARK: - Display alert view controller for failed login
    
    func displayAlertView(message: String) {
        
        let alertController = UIAlertController(title: "Login Failed", message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default) { (action) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        alertController.addAction(action)
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
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

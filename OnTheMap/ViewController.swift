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

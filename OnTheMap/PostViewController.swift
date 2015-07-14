//
//  PostViewController.swift
//  OnTheMap
//
//  Created by Troutslayer33 on 7/7/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class PostViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    

    var location: MKPlacemark?
    
    var lat: Double?
    var lon: Double?
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func cancelPost(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitLocation(sender: AnyObject) {
        
        if !self.linkTextField.text.isEmpty {
            
            let url = NSURL(string: self.linkTextField.text!)
            if url != nil {
                
                if (url!.scheme != nil && url!.host != nil) {
                    
                    OTMClient.sharedInstance.mapString = self.mapTextField.text
                    OTMClient.sharedInstance.mediaURL = self.linkTextField.text
                    OTMClient.sharedInstance.latitude = self.lat!
                    OTMClient.sharedInstance.longitude = self.lon!
                    OTMClient.sharedInstance.taskForPostLinkMethod(){ (success: Bool, res: Int?, error: NSError?) -> Void in
                        
                        if success == true {
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                        } else {
                            
                            self.displayError(success, res: res, error:error)
                            
                        }
                    }
                } else {
                    
                    self.displayAlertView("The URL is invalid.")
                    
                }

            }
            
        } else {
            
            self.displayAlertView("Please enter a link to submit.")
            
        }
        
    }
    
        @IBAction func findLocation(sender: AnyObject) {
        
        searchGeocodeForLocation()
        
    }
    
    func searchGeocodeForLocation() {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapTextField.text){ (placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            
            if error != nil {
                
                self.displayAlertView("The Location Could Not Be Found")
                
            }
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                self.lat = placemark.location.coordinate.latitude
                self.lon = placemark.location.coordinate.longitude
                self.location = MKPlacemark(placemark: placemark)
                self.mapView.hidden = false
                self.linkTextField.hidden = false
                self.submitButton.hidden = false
                self.findButton.hidden = true
                self.questionLabel.hidden = true
                self.mapView.addAnnotation(self.location!)
                self.mapView.showAnnotations([self.location!], animated: true)
                self.mapTextField.hidden = true
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.mapView.hidden = true
        self.linkTextField.hidden = true
        self.submitButton.hidden = true
        self.activityIndicator.hidden = true
        subscribeToKeyboardNotification()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotification()
        
    }
    
    func statusCodeCheck(statusCode: Int) {
        
        switch statusCode {
            
        case 400:
            self.displayAlertView("Your data could not be posted")
        default:
            break
            
        }
        
    }
    
    func displayAlertView(message: String) {
        
        let alertController = UIAlertController(title: "Post Error", message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    func subscribeToKeyboardNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeToKeyboardNotification() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if UIDevice.currentDevice().orientation == .LandscapeLeft ||  UIDevice.currentDevice().orientation == .LandscapeRight {
            
            self.view.frame.origin.y = -getKeyboardHeight(notification) + 20
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y = CGFloat(0)
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
        
    }
    
    func displayError(success: Bool, res: Int?, error: NSError?) {
        
        if res != nil {
            
            self.statusCodeCheck(res!)
            
        } else {
            
            self.displayAlertView("Networking Error")
            
        }
        
    }
    
}

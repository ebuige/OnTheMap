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
    @IBAction func submitTapped(sender: AnyObject) {
        
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
                    
                }
                
            } else {
                
                self.displayAlertView("The url is invalid.")
                
            }
            
        } else {
            
            self.displayAlertView("You gotta put a link to submit.")
            
        }
        
    }
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTextField: UITextField!
    @IBAction func buttonTapped(sender: AnyObject) {
        
        searchGeocodeForLocation()
        
    }
    
    func searchGeocodeForLocation() {
        
        
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapTextField.text){ (placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            if error != nil {
                
                self.displayAlertView("Sorry, we couldn't find your location...")
                
            }
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                self.lat = placemark.location.coordinate.latitude
                self.lon = placemark.location.coordinate.longitude
                self.location = MKPlacemark(placemark: placemark)
                self.mapView.hidden = false
                self.linkTextField.hidden = false
                self.submitButton.hidden = false
                self.findButton.hidden = true
  //              self.view.backgroundColor = UIColor.rgb(0, g: 89, b: 187, alpha: 1)
                self.mapView.addAnnotation(self.location!)
                self.mapView.showAnnotations([self.location!], animated: true)
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
  //      mapTextField.delegate = self
  //      linkTextField.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
 //       mapTextField.text = nil
        subscribeToKeyboardNotification()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotification()
        
    }
    
    func statusCodeChecker(statusCode: Int) {
        
        switch statusCode {
            
        case 400:
            self.displayAlertView("Sorry, we couldn't post your data.")
        default:
            break
            
        }
        
    }
    
    func displayAlertView(message: String) {
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default) { (action) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
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
            
            self.statusCodeChecker(res!)
            
        } else {
            
            self.displayAlertView("Networking Error")
            
        }
        
    }
    
}
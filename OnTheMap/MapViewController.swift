//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Troutslayer33 on 7/7/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    var appDelegate: AppDelegate!
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet weak var post: UIBarButtonItem!
    
    @IBAction func logout(sender: AnyObject) {
        OTMClient.sharedInstance.taskForDeleteMethod() { (success: Bool, res: Int?, error: NSError?) -> Void in
            
            if success {
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                
                self.displayAlertView("Failed to Logout")
            }
        }

    }
    
    @IBAction func refreshStudentInfo(sender: AnyObject) {
        addAnnotations()
    }
    
    @IBAction func postStudentInfo(sender: AnyObject) {
        let postvc = self.storyboard?.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
        self.presentViewController(postvc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        addAnnotations()
        
    }
    
    
    func addAnnotations() {
        
        getStudentLocation()
        
    }
    
    func getStudentLocation() {
        
        if OTMClient.sharedInstance.studentInfo != nil {
            
           self.mapView.removeAnnotations(self.annotations)
            
        }
        OTMClient.sharedInstance.taskForGetMethod(100) { (success: Bool, res: Int?, error: NSError?) -> Void in
            
            if success == true {
                
                for item in OTMClient.sharedInstance.studentInfo! {
                    
                    let lat = CLLocationDegrees(item["latitude"] as! Double)
                    let long = CLLocationDegrees(item["longitude"] as! Double)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = item["firstName"] as! String
                    let last = item["lastName"] as! String
                    let mediaURL = item["mediaURL"] as! String
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL

                    self.annotations.append(annotation)
                    
                    let studentInfo = StudentInfo(data: item)
                    self.appDelegate.udacityStudents.append(studentInfo)
    
               }
       //           self.mapView.addAnnotation(self.annotations)
                self.mapView.addAnnotations(self.annotations)
                self.mapView.showAnnotations(self.annotations, animated: true)


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
    
    
       
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(OTMClient.Constants.reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: OTMClient.Constants.reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
            
        } else {
            
            pinView!.annotation = annotation
            
        }
        
        return pinView
        
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        if control == view.rightCalloutAccessoryView {
            
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: view.annotation.subtitle!)!)
            
        }
        
    }
    
    func statusCodeCheck(statusCode: Int) {
        
        switch statusCode {
            
        case 400:
            self.displayAlertView("No Data Found")
        default:
            break
            
        }
        
    }
    
    func displayAlertView(message: String) {
        
        let alertController = UIAlertController(title: "Possible Network Issue", message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default) { (action) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}

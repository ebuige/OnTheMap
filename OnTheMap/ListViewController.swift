//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Troutslayer33 on 7/7/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var post: UIBarButtonItem!
    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var udacityStudents = [StudentInfo]()
    var urlString: String?
    
    
    @IBAction func refreshStudentInfo(sender: AnyObject) {
        getStudentinfo()
    }
        
    @IBAction func postStudentInfo(sender: AnyObject) {
        let postvc = self.storyboard?.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
        self.presentViewController(postvc, animated: true, completion: nil)
    }
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
      //  getStudentinfo()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getStudentinfo()
        
            }

    
    func getStudentinfo() {
        
        println("call student info")
        
        OTMClient.sharedInstance.taskForGetMethod(100) {
            
            (success: Bool, res: Int?, error: NSError?) -> Void in
            
            if success == true {
                
                for item in OTMClient.sharedInstance.studentInfo! {
                    
                    let studentInfo = StudentInfo(data: item)
                    self.udacityStudents.append(studentInfo)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }

                    
                }
                
            } else {
                
                self.displayError(success, res: res, error:error)
                
            }
            
            
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      //  println("student count = \(udacityStudents.count)")
        return udacityStudents.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("StudentCell", forIndexPath: indexPath) as! UITableViewCell
        if udacityStudents.count > 0 {
            
            cell.imageView?.image = UIImage(named: "Pin")
            cell.textLabel?.text = udacityStudents[indexPath.row].name
            
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        self.urlString = udacityStudents[indexPath.row].info ?? OTMClient.Constants.UdacityURLSecure
        var url : NSURL
        url = NSURL(string: self.urlString!)!
        UIApplication.sharedApplication().openURL(url)
        
    }
    
    
    func displayError(success: Bool, res: Int?, error: NSError?) {
        
        if res != nil {
            
            self.statusCodeCheck(res!)
            
        } else {
            
            self.displayAlertView("Networking Error")
            
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
        
        let alertController = UIAlertController(title: "Download Error / Possible Network Issue", message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default) { (action) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}

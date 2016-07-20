//
//  PopupTestViewController.swift
//  Walkhome
//
//  Created by Raymond Chung on 2016-07-20.
//  Copyright © 2016 COMPSA Web Services. All rights reserved.
//

import UIKit

class PopupTestViewController: UIViewController {

    var messageTitle = String()
    var message = String()
    @IBAction func Pop4pmA(sender: AnyObject) {
        let alertA = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertA.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertA, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Note: This is all in military time based on phone's clock setting
        let date = NSDate()
        let dateUnits: NSCalendarUnit = [.Month, .Weekday, .Day, .Hour, .Minute]
        let components = NSCalendar.currentCalendar().components(dateUnits, fromDate: date)

        if (components.hour != 16) {
            messageTitle = "The watch has ended"
            message = "We are closed"
        } else {
            messageTitle = "The watch begun"
            message = "We are open"
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

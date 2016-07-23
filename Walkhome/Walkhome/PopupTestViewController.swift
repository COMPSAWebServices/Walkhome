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
    var oper = Bool()
    @IBAction func Pop4pmA(sender: AnyObject) {
        let url:NSURL = NSURL(string: "tel://")!
        let alertA = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertA.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        if (oper == true) {
            alertA.addAction(UIAlertAction(title: "Call Someone", style: UIAlertActionStyle.Default,handler: { UIAlertAction in UIApplication.sharedApplication().openURL(url)}))
        }
        self.presentViewController(alertA, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Note: This is all in military time based on phone's clock setting
        //Note: I am missing some base cases and I will forsure be redoing this as to improve the complexity and fix some mistakes I made
        let date = NSDate()
        let dateUnits: NSCalendarUnit = [.Month, .WeekOfYear, .Weekday, .Hour]
        let components = NSCalendar.currentCalendar().components(dateUnits, fromDate: date)

        //Covers school year, summer and exam
        if (((components.month >= 5 && components.month <= 8) && (components.hour >= 1 && components.hour < 21)) || ((components.month == 4 || components.month == 12) && (components.weekday == 1 || components.weekday == 2) && (components.hour >= 4 && components.hour < 20)) || (((components.month >= 9 || components.month <= 12) || (components.month >= 1 || components.month <= 4)) && (((components.weekday >= 2 && components.weekday <= 5) && (components.hour >= 2 && components.hour < 21)) || ((components.weekday == 6 || components.weekday == 7 || components.weekday == 1) && (components.hour >= 3 && components.hour < 21))))) {
            oper = true
            messageTitle = "The watch has ended"
            message = "Call Samal"
        } else if ((components.weekOfYear == 41 && components.weekday == 2) || ((components.weekOfYear == 51 && (components.weekday >= 4 && components.weekday <= 7)) || components.weekOfYear == 52 || components.weekOfYear == 1)) { //Thanksgiving & Winter Holiday
            oper = true
            messageTitle = "We are closed for the holiday!"
            message = "We will resume operations first day back"
        } else { //Operating hours
            oper = false
            messageTitle = "We are open"
            message = "Request a walk!"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

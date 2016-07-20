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
        //Note: I am missing some base cases and I will forsure be redoing this as to improve the complexity and fix some mistakes I made
        let date = NSDate()
        let dateUnits: NSCalendarUnit = [.Month, .Weekday, .Day, .Hour, .Minute]
        let components = NSCalendar.currentCalendar().components(dateUnits, fromDate: date)

        //Summer (May to August)
        if (components.month >= 5 && components.month <= 8) {
            //Hours between 9pm to 1am daily
            if ((components.hour >= 21 && components.hour <= 24) || components.hour == 1) {
                messageTitle = "The watch begins"
                message = "We are open"
            } else {
                messageTitle = "The watch has ended"
                message = "We are closed"
            }
        } else { //School Year
            //Exam Season
            if (components.month == 4 || components.month == 12) {
                if (((components.weekday == 6 || components.weekday == 7) && (components.hour >= 20 && components.hour <= 24)) || ((components.weekday == 1 || components.weekday == 7) && (components.hour >= 1 && components.hour <= 4))) { //8pm to 4am
                    messageTitle = "The watch begins"
                    message = "We are open"
                } else {
                    messageTitle = "The watch has ended"
                    message = "We are closed"
                }
            } else { //Regular Operating Hours
                if ((components.weekday == 7 || (components.weekday >= 1 && components.weekday <= 3)) && ((components.hour >= 21 && components.hour <= 24) || (components.weekday == 4 && (components.hour >= 0 && components.hour <= 2)))) {
                    messageTitle = "The watch begins"
                    message = "We are open"
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

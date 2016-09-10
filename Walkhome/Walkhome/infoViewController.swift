//
//  infoViewController.swift
//  Walkhome
//
//  Created by Lucas Bullen on 2016-09-02.
//  Copyright © 2016 COMPSA Web Services. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var callCSButton: UIButton!
    
    override func viewDidLoad() {
        feedbackButton.layer.cornerRadius = 5
        feedbackButton.layer.borderWidth = 0
        
        callButton.layer.cornerRadius = 5
        callButton.layer.borderWidth = 0
        
        callCSButton.layer.cornerRadius = 5
        callCSButton.layer.borderWidth = 0
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func returnToMap(sender: AnyObject) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! NewMapViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    @IBAction func callWalkhome(sender: AnyObject) {
        api().call()
    }
    
    @IBAction func callCS(sender: AnyObject) {
        api().callCS()
    }
    
    @IBAction func feedbackSwitch(sender: AnyObject) {
        accessData().set("last_screen", value: "infoView")
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("feedbackView") as! FeedbackViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
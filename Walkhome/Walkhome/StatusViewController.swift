//
//  StatusViewController.swift
//  Walkhome
//
//  Created by Lucas Bullen on 2016-07-18.
//  Copyright © 2016 COMPSA Web Services. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {
    
    @IBOutlet weak var statusBar: UINavigationItem!
    
    @IBOutlet weak var progImg1: UIImageView!
    @IBOutlet weak var progImg2: UIImageView!
    @IBOutlet weak var progImg3: UIImageView!
    @IBOutlet weak var progImg4: UIImageView!
    @IBOutlet weak var progImg5: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let status: String = accessPlist().get("walk", field: "status")! as String
        if let statusInt: Int = Int(status)! {
            setProg(statusInt)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func feedback(sender: AnyObject) {
    }
    @IBAction func callWalkhome(sender: AnyObject) {
        //todo: move to different module
    }
    @IBAction func viewMap(sender: AnyObject) {
    }
    
    func refresh(){
        //change nothing to LOADING
        let phone_number: String = accessPlist().get("user", field: "phone_number")!
        api().get(["function":"getWalkByUserPhoneNumber","phone_number":phone_number], onReturn: SetRefresh)
    }
    func SetRefresh(JSON: NSDictionary){
        let status = String(JSON["status"]!)
        let active = String(JSON["walk"]!["active"]!)
        if(status == "200" && active == "1"){
            accessPlist().set("walk", field: "id", value: JSON["walk"]!["id"] as! String)
            accessPlist().set("walk", field: "pick_up_location", value: JSON["walk"]!["pick_up_location"] as! String)
            accessPlist().set("walk", field: "drop_off_location", value: JSON["walk"]!["drop_off_location"] as! String)
            accessPlist().set("walk", field: "status", value: JSON["walk"]!["status"] as! String)
            accessPlist().set("walk", field: "active", value: JSON["walk"]!["active"] as! String)
            
            if let statusInt: Int = Int(JSON["walk"]!["status"] as! String)! {
                setProg(statusInt)
            }
            //change LOADING to nothing
        }else if (status == "200" && active == "0"){
            //switch to feedback
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("feedbackView") as! FeedbackViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }else{
            //switch to map
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! UINavigationController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func setProg(status:Int){
        if(status >= 0){//sent
            //progImg1.image =
            statusBar.title = "Request Sent"
        }
        if(status >= 1){//recived
            //progImg2.image =
            statusBar.title = "Request Recived"
        }
        if(status >= 2){//walkers out
            //progImg3.image =
            statusBar.title = "Walkers on Their Way"
        }
        if(status >= 3){//walking
            //progImg4.image =
            statusBar.title = "Walking"
        }
        if(status >= 4){//done
            //progImg5.image =
            statusBar.title = "Completed"
        }
    }
}
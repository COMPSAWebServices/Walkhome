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
    
    @IBOutlet weak var statusText: UITextView!
    
    @IBOutlet weak var progText1: UILabel!
    @IBOutlet weak var progText2: UILabel!
    @IBOutlet weak var progText3: UILabel!
    @IBOutlet weak var progText4: UILabel!
    @IBOutlet weak var progText5: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    
    
    override func viewDidLoad() {
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 0
        
        callButton.layer.cornerRadius = 5
        callButton.layer.borderWidth = 0
        
        feedbackButton.layer.cornerRadius = 5
        feedbackButton.layer.borderWidth = 0
        super.viewDidLoad()
        let phone_number: String = accessData().get("phone_number")!
        api().get(["function":"getWalkByUserPhoneNumber","phone_number":phone_number], onReturn: showStatus)
    }
    func showStatus(JSON:NSDictionary){
        let status = String(JSON["status"]!)
        if(status == "200"){
            let active = String(JSON["walk"]!["active"]!!)
            print("active: \(active)")
            let status = String(JSON["walk"]!["status"]!!)
            print("status: \(status)")
            if(active == "1" && status != "4" && status != "5"){
                //save walk
                accessData().get("phone_number")!
                accessData().set("id", value: JSON["walk"]!["id"] as! String)
                accessData().set("pick_up_location", value: JSON["walk"]!["pick_up_location"] as! String)
                accessData().set("drop_off_location", value: JSON["walk"]!["drop_off_location"] as! String)
                accessData().set("status", value: JSON["walk"]!["status"] as! String)
                accessData().set("active", value: JSON["walk"]!["active"] as! String)
                //switch to progress
                if let statusInt: Int = Int(status)! {
                    print(statusInt)
                    setProg(statusInt)
                }
            }else{
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! NewMapViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }else{
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! NewMapViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelWalk(sender: AnyObject) {
        let id = accessData().get("id")
        api().get(["function":"cancelWalk","id":id!], onReturn: walkCancelled)
    }
    
    func walkCancelled(JSON:NSDictionary){
        accessData().set("id", value: "")
        accessData().set("pick_up_location", value: "")
        accessData().set("drop_off_location", value: "")
        accessData().set("status", value: "1")
        accessData().set("active", value: "")
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! NewMapViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func feedback(sender: AnyObject) {
        accessData().set("last_screen", value: "statusView")
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("feedbackView") as! FeedbackViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    @IBAction func callWalkhome(sender: AnyObject) {
        //todo: move to different module
        api().call()
    }
    
    func refresh(){
        //change nothing to LOADING
        let phone_number: String = accessData().get("phone_number")!
        api().get(["function":"getWalkByUserPhoneNumber","phone_number":phone_number], onReturn: SetRefresh)
    }
    func SetRefresh(JSON: NSDictionary){
        let status = String(JSON["status"]!)
        let active = String(JSON["walk"]!["active"]!)
        if(status == "200" && active == "1"){
            accessData().set("id", value: JSON["walk"]!["id"] as! String)
            accessData().set("pick_up_location", value: JSON["walk"]!["pick_up_location"] as! String)
            accessData().set("drop_off_location", value: JSON["walk"]!["drop_off_location"] as! String)
            accessData().set("status", value: JSON["walk"]!["status"] as! String)
            accessData().set("active", value: JSON["walk"]!["active"] as! String)
            
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
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! NewMapViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func setProg(status:Int){
        print(status)
        if(status == 0){//sent
            statusBar.title = "Request Sent"
            progText1.textColor = UIColor.init(red: 102, green: 102, blue: 102, alpha: 1)
            statusText.text = "Your request for a walk is being sent to us now."
        }else if(status == 1){//recived
            statusBar.title = "Request Received"
            progText2.textColor = UIColor.init(red: 102, green: 102, blue: 102, alpha: 1)
            statusText.text = "Your request has been received. The next available walking team will be heading your way."
        }else if(status == 2){//walkers out
            statusBar.title = "Walkers on Their Way"
            progText3.textColor = UIColor.init(red: 102, green: 102, blue: 102, alpha: 1)
            statusText.text = "Your walking team is heading your way now."
        }else if(status == 3){//walking
            statusBar.title = "Walking"
            progText4.textColor = UIColor.init(red: 102, green: 102, blue: 102, alpha: 1)
            statusText.text = "You are currently on a walk with our walking team."
        }else if(status >= 4){//done
            statusBar.title = "Completed"
            progText5.textColor = UIColor.init(red: 102, green: 102, blue: 102, alpha: 1)
            statusText.text = "The walk has been completed."
        }
    }
}
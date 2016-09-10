//
//  FeedbackViewController.swift
//  Walkhome
//
//  Created by Lucas Bullen on 2016-07-18.
//  Copyright © 2016 COMPSA Web Services. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var notes: UITextView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var locationSwitch: UISwitch!

    override func viewDidLoad() {
        doneButton.layer.cornerRadius = 5
        doneButton.layer.borderWidth = 0
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        notes.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func done(sender: AnyObject) {
        let message = notes.text
        let locationBool = locationSwitch.on
        var user_info = "none"
        if locationBool {
            user_info = accessData().get("phone_number")!
        }
        let time = accessData().get("time")
        api().get(["function":"feedback","message":message, "time":time!, "phone_number":"\(user_info)"], onReturn: goToMap)
    }
    func goToMap(JSON: NSDictionary){
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! NewMapViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }

    @IBAction func cancel(sender: AnyObject) {
        let lastScreen = accessData().get("last_screen")
        if lastScreen == "mapView" {
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! NewMapViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }else if lastScreen == "statusView"{
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("statusView") as! StatusViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }else if lastScreen == "infoView"{
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("infoView") as! InfoViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }else{
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! NewMapViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
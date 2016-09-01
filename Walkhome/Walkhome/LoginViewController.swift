//
//  LoginViewController.swift
//  Walkhome
//
//  Created by Lucas Bullen on 2016-07-17.
//  Copyright © 2016 COMPSA Web Services. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var phonenumberError: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let phone_number: String = accessPlist().get("user", field: "phone_number")!
        print("phone_number:\(phone_number)")
        let device_token: String = accessPlist().get("user", field: "device_token")!
        if (phone_number == "") {
        }else{
            phoneTextField.text = phone_number
            if (device_token != "" && device_token != "<null>") {
                api().get(["function":"createUser","phone":phone_number,"device_token":device_token], onReturn: getUser)
            }else{
                //Do not have device token
                api().get(["function":"createUser","phone":phone_number], onReturn: getUser)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        let phone_number:String = phoneTextField.text!
        if checkPhoneNumber(phone_number) {
            accessPlist().set("user", field: "phone_number", value: phoneTextField.text!)
            let phone_number: String = accessPlist().get("user", field: "phone_number")!
            print("phone_number:\(phone_number)")
            let device_token: String = accessPlist().get("user", field: "device_token")!
            //todo: disable button
            if (device_token != "" && device_token != "<null>") {
                api().get(["function":"createUser", "phone": phoneTextField.text!,"device_token":device_token], onReturn: getUser)
            }else{
                api().get(["function":"createUser", "phone": phoneTextField.text!], onReturn: getUser)
            }
        }
    }
    
    func getUser(JSON: NSDictionary) {
        print(JSON)
        let status = String(JSON["status"]!)
        print(status)
        if (status == "201"){
            let phone_number: String = accessPlist().get("user", field: "phone_number")!
            api().get(["function":"getWalkByUserPhoneNumber","phone_number":phone_number], onReturn: checkCurrentWalk)
            
        }else{
            //switchView to map
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! UINavigationController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func checkCurrentWalk(JSON: NSDictionary){
        let status = String(JSON["status"]!)
        let active = String(JSON["walk"]!["active"]!!)
        print("active: \(active)")
        print("status: \(status)")
        if(status == "200" && active == "1"){
            //save walk
            accessPlist().get("user", field: "phone_number")!
            accessPlist().set("walk", field: "id", value: JSON["walk"]!["id"] as! String)
            accessPlist().set("walk", field: "pick_up_location", value: JSON["walk"]!["pick_up_location"] as! String)
            accessPlist().set("walk", field: "drop_off_location", value: JSON["walk"]!["drop_off_location"] as! String)
            accessPlist().set("walk", field: "status", value: JSON["walk"]!["status"] as! String)
            accessPlist().set("walk", field: "active", value: JSON["walk"]!["active"] as! String)
            //switch to progress
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("statusView") as! StatusViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func checkPhoneNumber(phone_number:String)->Bool{
        var errorCode: String = ""
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(phone_number)
        if phone_number == "" {
            errorCode = "Can not have an empty phone number"
        }else if result {
            errorCode = "That isn't a phone number"
        }
        phonenumberError.text = errorCode
        return errorCode == ""
    }
}

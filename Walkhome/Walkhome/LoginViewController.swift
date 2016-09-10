//
//  LoginViewController.swift
//  Walkhome
//
//  Created by Lucas Bullen on 2016-07-17.
//  Copyright © 2016 COMPSA Web Services. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var phonenumberError: UILabel!

    override func viewDidLoad() {
        //loginButton.backgroundColor = UIColor.clearColor()
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 0

        super.viewDidLoad()
        self.phoneTextField.delegate = self;
        let phone_number: String = accessData().get("phone_number")!
        let device_token: String = accessData().get("device_token")!
        if (phone_number == "") {
            accessData().set("id", value: "")
            accessData().set("pick_up_location", value: "")
            accessData().set("drop_off_location", value: "")
            accessData().set("status", value: "1")
            accessData().set("active", value: "")
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
    
    override func viewDidAppear(animated: Bool){
        if Reachability.isConnectedToNetwork() == true {
            api().get(["function":"isOpen"], onReturn: checkIfOpen)
        } else {
            Pop4pmA("No Internet",message: "Call WH Instead",oper: "6135339255")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        let phone_number:String = phoneTextField.text!
        if checkPhoneNumber(phone_number) {
            accessData().set("phone_number", value: phoneTextField.text!)
            let phone_number: String = accessData().get("phone_number")!
            print("phone_number:\(phone_number)")
            let device_token: String = accessData().get("device_token")!
            //todo: disable button
            if (device_token != "" && device_token != "<null>") {
                api().get(["function":"createUser", "phone": phoneTextField.text!,"device_token":device_token], onReturn: getUser)
            }else{
                api().get(["function":"createUser", "phone": phoneTextField.text!], onReturn: getUser)
            }
        }
    }
    
    func getUser(JSON: NSDictionary) {
        let status = String(JSON["status"]!)
        if (status == "201"){
            let phone_number: String = accessData().get("phone_number")!
            api().get(["function":"getWalkByUserPhoneNumber","phone_number":phone_number], onReturn: checkCurrentWalk)
            
        }else{
            //switchView to map
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! NewMapViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func checkCurrentWalk(JSON: NSDictionary){
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
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("statusView") as! StatusViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }else{
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! NewMapViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }else{
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! NewMapViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func checkPhoneNumber(phone_number:String)->Bool{
        var errorCode: String = ""
        let PHONE_REGEX = "^\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(phone_number)
        print(result)
        if phone_number == "" {
            print("no number")
            errorCode = "Must enter phone number"
        }else if !result {
            print("not a number")
            errorCode = "That isn't a phone number"
        }
        print("out")
        phonenumberError.text = errorCode
        return errorCode == ""
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func closeNumberPad(sender: AnyObject) {
        self.view.endEditing(true)
    }

    func checkIfOpen(JSON:NSDictionary){
        var messageTitle = String()
        var message = String()
        let oper = "6135461111"
        let openStatus: String = "\(JSON["status"])"
        
        if (openStatus == "201") {
            messageTitle = "We are closed"
            message = "Call Amey's Taxi"
            loginButton.setTitle("Closed", forState: .Normal)
            //loginButton.enabled = false
            Pop4pmA(messageTitle,message: message,oper: oper)
        } else if (openStatus == "202") { //Thanksgiving & Winter Holiday
            messageTitle = "We are closed for the holiday!"
            message = "We will resume operations first day back"
            loginButton.setTitle("Closed", forState: .Normal)
            //loginButton.enabled = false
            Pop4pmA(messageTitle,message: message,oper: oper)
        }else{
            loginButton.setTitle("Login", forState: .Normal)
            loginButton.enabled = true
        }
    }
    
    func Pop4pmA(messageTitle:String,message:String, oper:String) {
        let url:NSURL = NSURL(string: "tel://\(oper)")!
        let alertA = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertA.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        if oper != "" {
            alertA.addAction(UIAlertAction(title: "Call", style: UIAlertActionStyle.Default,handler: { UIAlertAction in UIApplication.sharedApplication().openURL(url)}))
        }
        self.presentViewController(alertA, animated: true, completion: nil)
    }
}

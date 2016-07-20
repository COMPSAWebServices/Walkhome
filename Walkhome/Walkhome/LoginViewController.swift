//
//  LoginViewController.swift
//  Walkhome
//
//  Created by Lucas Bullen on 2016-07-17.
//  Copyright © 2016 COMPSA Web Services. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var phonenumberError: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let user: NSDictionary = accessPlist().get("user", field: "id", value: "1")![0] as! NSDictionary
        let username:String = user["username"] as! String
        let phone_number:String =  user["phone_number"] as! String
        if (username != "" && phone_number != "") {
            usernameTextField.text = user["username"] as? String
            phoneTextField.text = user["phone_number"] as? String
            api().postRequest("login.php", parameters: ["username":username,"phone_number":phone_number], onReturn: showMessages)
        }else{
            //switchView
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        let username:String = usernameTextField.text!
        let phone_number:String = phoneTextField.text!
        if checkUsername(username) && checkPhoneNumber(phone_number) {
            accessPlist().update("user", get_field: "id", get_value: "0", set_field: "username", set_value: usernameTextField.text!)
            accessPlist().update("user", get_field: "id", get_value: "0", set_field: "phone_number", set_value: phoneTextField.text!)
            //todo: disable button
            api().postRequest("login.php", parameters: ["username":username,"phone_number":phone_number], onReturn: showMessages)
        }else{
            //todo: enable button
        }
    }
    
    func showMessages(messages: NSDictionary) {
        print(messages)
        //switchView
    }
    
    func switchView(view:UIView){
        
    }
    func checkUsername(username:String)->Bool{
        var errorCode: String = ""
        if username == "" {
            errorCode = "Can not have an empty username"
        }else if false/*username has non letter number char*/ {
            errorCode = "Username can only contain letters and numbers"
        }
        if errorCode == "" {
            return true
        }else{
            usernameError.text = errorCode
            return false
        }
    }
    
    func checkPhoneNumber(phone_number:String)->Bool{
        var errorCode: String = ""
        if phone_number == "" {
            errorCode = "Can not have an empty phone number"
        }else if false/*phone_number is not a phone number*/ {
            errorCode = "That isn't a phone number"
        }
        if errorCode == "" {
            return true
        }else{
            phonenumberError.text = errorCode
            return false
        }
    }
}

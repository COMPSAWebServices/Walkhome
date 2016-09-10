//
//  WHAPI.swift
//  Walkhome
//
//  Created by Lucas Bullen on 2016-07-17.
//  Copyright © 2016 COMPSA Web Services. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class api {
    let baseURL = "http://backstage.compsawebservices.com/walkhome/api.php"
    /* Sending get requests to our backend
     * @param parameters {Dictionary<String, String>}: All the parapeters
     * @param onReturn {(NSDictionary) -> Void}: The desired function to recive the responce from the call
     * Example: api().get(["function":"createUser","phone_number":"6131234567"], onReturn: printReturn)
     */
    func get(parameters: Dictionary<String, String>, onReturn:(NSDictionary) -> Void) {
        Alamofire.request(.GET, baseURL, parameters: parameters)
            .responseJSON { response in
                print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                if let JSON = response.result.value {
                    onReturn(JSON as! NSDictionary)
                    print("JSON: \(JSON)")
                }else{
                    onReturn(["status":"500"]);
                }
        }
    }
    func call(){
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://6135339255")!)
    }
    func callCS(){
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://6135336733")!)
    }
}
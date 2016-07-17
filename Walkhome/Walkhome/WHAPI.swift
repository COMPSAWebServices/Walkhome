//
//  WHAPI.swift
//  Walkhome
//
//  Created by Lucas Bullen on 2016-07-17.
//  Copyright © 2016 COMPSA Web Services. All rights reserved.
//

import Foundation

class api {
    let baseURL = "http://api.compsawebservices.com/walkhome/"
    /* Sending post requests to our backend
     * @param endpoint {String}: The desired endpoint for the post call
     * @param parameters {Dictionary<String, String>}: All the parapeters
     * @param onReturn {(NSDictionary) -> Void}: The desired function to recive the responce from the call
     * Example: api().postRequest("log_in", parameters: ["username":"stevejobs4567","phone_number":"6131234567"], onReturn: printReturn)
    */
    func postRequest(endpoint:String, parameters: Dictionary<String, String>, onReturn:(NSDictionary) -> Void){
        //create the url with NSURL
        let requestURL = NSURL(string: (baseURL + endpoint + "/"))
        
        //create the session object
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "POST" //set http method as POST
        
        do{
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: []) // pass dictionary to nsdata object and set it as request body
        }catch{
            print("parameters not in a proper JSON format")
        }
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setBodyContent(parameters)
        //create dataTask using the session object to send data to the server
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            //let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print("Body: \(strData)")
            let json = try!NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as! NSDictionary
            //print("account data")

            onReturn((json as NSDictionary?)!)
            
            if(error != nil) {
                //print(error!.localizedDescription)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                if let parseJSON = json as NSDictionary! {
                    //let success = parseJSON["success"] as? Int
                    //print("Succes: \(success)")
                }
                else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                }
            }
            
        })
        
        task.resume()
    }
}
extension NSMutableURLRequest {
    func setBodyContent(contentMap: Dictionary<String, String>) {
        var firstOneAdded = false
        var contentBodyAsString = String()
        let contentKeys:Array<String> = Array(contentMap.keys)
        for contentKey in contentKeys {
            if(!firstOneAdded) {
                contentBodyAsString = contentBodyAsString + contentKey + "=" + contentMap[contentKey]!
                firstOneAdded = true
            }
            else {
                contentBodyAsString = contentBodyAsString + "&" + contentKey + "=" + contentMap[contentKey]!
            }
        }
        contentBodyAsString = contentBodyAsString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        self.HTTPBody = contentBodyAsString.dataUsingEncoding(NSUTF8StringEncoding)
    }
}
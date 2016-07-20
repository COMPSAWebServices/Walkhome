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
        let walk: NSDictionary = accessPlist().get("walk", field: "current", value: "1")![0] as! NSDictionary
        let status:Int = walk["status"] as! Int
        setProg(status)
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
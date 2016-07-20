//
//  FeedbackViewController.swift
//  Walkhome
//
//  Created by Lucas Bullen on 2016-07-18.
//  Copyright © 2016 COMPSA Web Services. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    @IBOutlet weak var notes: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func done(sender: AnyObject) {
    }
    @IBAction func cancel(sender: AnyObject) {
    }
}
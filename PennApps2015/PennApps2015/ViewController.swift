//
//  ViewController.swift
//  PennApps2015
//
//  Created by Calvin on 9/4/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, PaerUIDelegate
{

    @IBOutlet weak var Go: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Go(sender: AnyObject)
    {
        var paer = PaerManager(dictToSend: ["stuff": "things"])
        paer.delegate = self
        paer.start()
//        var stream = PaerStream(localMajor: 1, localMinor: 1, foreignMajor: 1, foreignMinor: 1)
//        stream.sendData(["Hi" : "Hello"])
    }
    
    func paerStarted() {
        println("UI Received: Paer Started")
    }
    
    func paerSavedContact(name: String) {
        
    }
    
    func paerFollowedTwitter(user: [String : AnyObject]) {
        
    }
    
    func paerFollowedInstagram(user: [String : AnyObject]) {
        
    }
    
    func paerCompleted() {
        
    }
    
    func paerTimedOut() {
        
    }
}


//
//  ViewController.swift
//  Twerk-and-Teach-iOS
//
//  Created by Calvin on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PaerUIDelegate {

    @IBOutlet weak var GoButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "channelcreated:", name: "channelcreated", object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Range(sender: AnyObject)
    {
        var paer = PaerManager(dictToSend: ["stuff": "things"])
        paer.delegate = self
        paer.start()
    }
    
    func channelcreated(notification: NSNotification)
    {
        performSegueWithIdentifier("SegueToDataSend", sender: notification.object)
        NSNotificationCenter.defaultCenter().removeObserver(notification)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToDataSend"
        {
            var dvc = segue.destinationViewController as! DataSendTest
            dvc.stream = sender as! PaerStream
            
        }
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


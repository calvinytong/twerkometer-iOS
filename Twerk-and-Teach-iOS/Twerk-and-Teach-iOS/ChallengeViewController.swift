//
//  ChallengeViewController.swift
//  Twerk-and-Teach-iOS
//
//  Created by Calvin on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import UIKit

class ChallengeViewController : UIViewController, PaerUIDelegate
{
    @IBOutlet weak var challengebutton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.challengebutton.layer.cornerRadius = self.challengebutton.bounds.size.width/2.0;
    }
    
    @IBAction func challenge(sender: AnyObject)
    {
        var paer = PaerManager()
        paer.delegate = self
        paer.start()
    }
    
    func channelcreated(notification: NSNotification)
    {
        performSegueWithIdentifier("SegueToPlayerFound", sender: notification.object)
        NSNotificationCenter.defaultCenter().removeObserver(notification)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToPlayerFound"
        {
            var dvc = segue.destinationViewController as! PlayerFoundViewController
            dvc.stream = sender as! PaerStream
            
        }
    }

    
    //delegate methods don't do much just here because hackathon
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

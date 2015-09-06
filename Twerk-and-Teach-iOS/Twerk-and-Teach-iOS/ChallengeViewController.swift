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
    var stream : PaerStream!
    
    
    override func viewDidLoad()
        
    {
        
        super.viewDidLoad()
        
        self.challengebutton.layer.cornerRadius = self.challengebutton.bounds.size.width/2.0;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "channelcreated:", name: "channelcreated", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "twoinchannel:", name: "twoinchannel", object: nil)
    }
    
    
    
    @IBAction func challenge(sender: AnyObject)
        
    {
        
        var paer = PaerManager()
        
        paer.delegate = self
        
        paer.start()
        
    }
    
    func channelcreated(notification: NSNotification) {
        stream = notification.object as! PaerStream
        NSNotificationCenter.defaultCenter().removeObserver(notification)
    }
    
    
    func twoinchannel(notification: NSNotification)
        
    {
        
        performSegueWithIdentifier("SegueToPlayerFound", sender: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(notification)
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SegueToPlayerFound"
            
        {
            
            var dvc = segue.destinationViewController as! PlayerFoundViewController
            
            dvc.stream = stream
            
            
            
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
//
//  PlayerFoundViewController.swift
//  Twerk-and-Teach-iOS
//
//  Created by Calvin on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import UIKit

class PlayerFoundViewController : UIViewController
{
    var stream : PaerStream!
    
    override func shouldAutorotate() -> Bool {
        
        return false
        
    }
    
    @IBOutlet weak var ptwolabel: UILabel!
    @IBOutlet weak var playbutton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setusername:", name: "setusername", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "join:", name: "join", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messagereceived:", name: "messagereceived", object: nil)
        ptwolabel.text = ""
        
        if(ptwolabel.text == "")
        {
            stream.sendData(["type": "identify", "username": stream.pOne.username])
            stream.sendData(["type": "identify", "username": stream.pOne.username])
            stream.sendData(["type": "identify", "username": stream.pOne.username])
            stream.sendData(["type": "identify", "username": stream.pOne.username])
        }
    
        
        //todo query for the username and change the label
    }
    
    
    @IBAction func play(sender: AnyObject)
    {
        performSegueWithIdentifier("SegueToBetScreen", sender: stream)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToBetScreen"
        {
            var dvc = segue.destinationViewController as! BetViewController
            dvc.stream = sender as! PaerStream!
            
        }
    }
    
    func setusername(notification: NSNotification) {
        ptwolabel.text = notification.object as? String
        NSNotificationCenter.defaultCenter().removeObserver(notification)
    }
    
    func join(notification: NSNotification)
    {
        if(ptwolabel.text == "")
        {
            stream.sendData(["type": "identify", "username": stream.pOne.username])
            stream.sendData(["type": "identify", "username": stream.pOne.username])
            stream.sendData(["type": "identify", "username": stream.pOne.username])
            stream.sendData(["type": "identify", "username": stream.pOne.username])
        }
    }
    
    func messagereceived(notification : NSNotification)
    {
        if(ptwolabel.text == "")
        {
            stream.sendData(["type": "identify", "username": stream.pOne.username])
            stream.sendData(["type": "identify", "username": stream.pOne.username])
            stream.sendData(["type": "identify", "username": stream.pOne.username])
            stream.sendData(["type": "identify", "username": stream.pOne.username])
        }
    }
}

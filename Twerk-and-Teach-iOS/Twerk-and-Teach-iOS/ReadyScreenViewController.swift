//
//  ReadyScreenViewController.swift
//  Twerk-and-Teach-iOS
//
//  Created by Calvin on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import UIKit

class ReadyScreenViewController : UIViewController
{
    var stream : PaerStream!
    @IBOutlet weak var Start: UIButton!
    
    override func shouldAutorotate() -> Bool {
        
        return false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "bothPReady:", name: "bothPReady", object: nil)
    }
    
    @IBAction func Start(sender: AnyObject)
    {
        stream.sendData(["type": "start"])
    }
    
    func bothPReady(notification: NSNotification) {
        performSegueWithIdentifier("SegueToTwerkViewController", sender: nil)
        NSNotificationCenter.defaultCenter().removeObserver(notification)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToTwerkViewController"
        {
            var dvc = segue.destinationViewController as! TwerkViewController
            dvc.stream = stream
        }
    }
}

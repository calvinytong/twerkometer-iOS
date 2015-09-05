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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Start(sender: AnyObject)
    {
        if stream.pOne.ready + stream.pTwo.ready == 2 {
            performSegueWithIdentifier("SegueToTwerkViewController", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToTwerkViewController"
        {
            var dvc = segue.destinationViewController as! TwerkViewController
            dvc.stream = sender as! PaerStream!
            
        }
    }
}

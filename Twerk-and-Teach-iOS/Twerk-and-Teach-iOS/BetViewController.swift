//
//  BetViewController.swift
//  Twerk-and-Teach-iOS
//
//  Created by Calvin on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import UIKit

class BetViewController : UIViewController
{
    var stream : PaerStream!
    
    @IBOutlet weak var betselector: UISegmentedControl!
    var segmentedControlArray: [Double] = [0.25, 0.5, 0.75, 1.00]
    @IBOutlet weak var confirmbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirm(sender: AnyObject)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(segmentedControlArray[betselector.selectedSegmentIndex], forKey: "bet")
        performSegueWithIdentifier("SegueToReadyScreen", sender: stream)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToReadyScreen"
        {
            var dvc = segue.destinationViewController as! ReadyScreenViewController
            dvc.stream = sender as! PaerStream
            
        }
    }

    
}

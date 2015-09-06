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
    
    override func shouldAutorotate() -> Bool {
        
        return false
        
    }
    
    @IBOutlet weak var betselector: UISegmentedControl!
    var segmentedControlArray: [Int] = [1, 2, 3, 5]
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

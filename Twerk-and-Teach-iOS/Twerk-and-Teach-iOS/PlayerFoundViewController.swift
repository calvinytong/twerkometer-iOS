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
    
    @IBOutlet weak var ptwolabel: UILabel!
    @IBOutlet weak var playbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
}

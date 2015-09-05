//
//  TwerkViewController.swift
//  PennApps2015
//
//  Created by Kevin Hui on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import UIKit
import CoreMotion

class TwerkViewController: UIViewController {
    
    @IBOutlet var timeRemainingLabel: UILabel!
    
    
    @IBOutlet var twerkCount: UILabel!
    
    var twerkInstance = twerkClass()
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        timeRemainingLabel?.text = "\(twerkInstance.timeRemaining)"
        twerkInstance.twerkMotionManager.accelerometerUpdateInterval = 0.2
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    @IBAction func start(sender: AnyObject) {
        if (twerkInstance.timeRemaining > 0) {
            twerkInstance.twerkMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: { (accelerometerData: CMAccelerometerData!, error: NSError!) -> Void in
                self.twerkInstance.outputAccelerationData(accelerometerData.acceleration)
                self.twerkCount?.text = "\(self.twerkInstance.shakeCount)"
                if (error != nil) {
                    println("\(error)")
                }
            })
            
            twerkInstance.timer = NSTimer(timeInterval: 1.0, target: self, selector: "countDown", userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(twerkInstance.timer, forMode: NSRunLoopCommonModes)
        }
    }
    
    func countDown() {
        twerkInstance.timeRemaining--
        timeRemainingLabel?.text = "\(twerkInstance.timeRemaining)"
        if (twerkInstance.timeRemaining == 0) {
            twerkInstance.timer.invalidate()
            twerkInstance.stop = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

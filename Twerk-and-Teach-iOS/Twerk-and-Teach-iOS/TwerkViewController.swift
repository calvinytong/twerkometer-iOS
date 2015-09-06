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
    
    var stream : PaerStream!
    
    @IBOutlet var timeRemainingLabel: UILabel!
    
    
    @IBOutlet var twerkCount: UILabel!
    
    var twerkInstance : twerkClass!
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        twerkInstance = twerkClass(stream: stream)
        
        timeRemainingLabel?.text = "\(twerkInstance.timeRemaining)"
        twerkInstance.twerkMotionManager.accelerometerUpdateInterval = 0.2
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "bothPFinished:", name: "bothPFinished", object: nil)
        
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
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func countDown() {
        twerkInstance.timeRemaining--
        timeRemainingLabel?.text = "\(twerkInstance.timeRemaining)"
        if (twerkInstance.timeRemaining == 0) {
            stream.sendData(["type": "finish", "score": twerkInstance.shakeCount])
            twerkInstance.timer.invalidate()
            twerkInstance.stop = true
        }
    }
    
    func bothPFinished(notification: NSNotification) {
        if stream.pOne.score >= stream.pTwo.score {
            performSegueWithIdentifier("SegueToWonViewController", sender: nil)
        }
        else {
            performSegueWithIdentifier("SegueToLostViewController", sender: nil)
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToLostViewController" {
            var dvc = segue.destinationViewController as! LostViewController
            dvc.pOneScore = stream.pOne.score
            dvc.pTwoScore = stream.pTwo.score
            dvc.stream = stream
        }
        if segue.identifier == "SegueToWonViewController" {
            var dvc = segue.destinationViewController as! WonViewController
            dvc.pOneScore = stream.pOne.score
            dvc.pTwoScore = stream.pTwo.score
            dvc.stream = stream

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

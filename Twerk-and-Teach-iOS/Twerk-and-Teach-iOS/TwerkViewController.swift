//
//  TwerkViewController.swift
//  PennApps2015
//
//  Created by Kevin Hui on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox
import AVFoundation

class TwerkViewController: UIViewController {
    
    var stream : PaerStream!
    
    @IBOutlet var timeRemainingLabel: UILabel!
    
    var songs = ["water", "barbra", "pbj", "saxobeat", "sandstorm", "Starships", "mambo",]
    var songindex : Int!
    var audioPlayer : AVAudioPlayer!
    
    @IBOutlet var twerkCount: UILabel!
    
    var twerkInstance : twerkClass!
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    
    override func viewDidLoad() {
        srand(5000)
        var temp = rand() % 7
        songindex = Int(temp)
        
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
            
            var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(songs[songindex], ofType: "wav")!)
            println(alertSound)
            
            // Removed deprecated use of AVAudioSessionDelegate protocol
            AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
            AVAudioSession.sharedInstance().setActive(true, error: nil)
            
            var error : NSError?
            audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            twerkInstance.timer = NSTimer(timeInterval: 1.0, target: self, selector: "countDown", userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(twerkInstance.timer, forMode: NSRunLoopCommonModes)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func countDown() {
        twerkInstance.timeRemaining--
        timeRemainingLabel?.text = "\(twerkInstance.timeRemaining)"
        if stream.pOne.score > stream.pTwo.score
        {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        if (twerkInstance.timeRemaining == 0) {
            stream.sendData(["type": "finish", "score": twerkInstance.shakeCount, "stdv": twerkInstance.stdv])
            twerkInstance.timer.invalidate()
            twerkInstance.stop = true
        }
    }
    
    func bothPFinished(notification: NSNotification) {
        if stream.pOne.stdv < stream.pTwo.stdv {
            stream.pOne.score += 5
        }
        else {
            stream.pTwo.score += 5
        }
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

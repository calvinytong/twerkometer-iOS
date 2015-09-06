//
//  WonViewController.swift
//  Twerk-and-Teach-iOS
//
//  Created by Calvin on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class WonViewController: UIViewController {
    var pOneScore: Int!
    var pTwoScore: Int!
    var stream : PaerStream!
    var audioPlayer : AVAudioPlayer!
    
    override func shouldAutorotate() -> Bool {
        
        return false
        
    }
    
    @IBOutlet var yourScore: UITextField!
    @IBOutlet var theirScore: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("5", ofType: "wav")!)
        println(alertSound)
        
        // Removed deprecated use of AVAudioSessionDelegate protocol
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error : NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        yourScore?.text = "\(pOneScore)"
        theirScore?.text = "\(pTwoScore)"
    }
    
    @IBAction func home(sender: AnyObject) {
        stream.zeroPlayers()
    }
    
}
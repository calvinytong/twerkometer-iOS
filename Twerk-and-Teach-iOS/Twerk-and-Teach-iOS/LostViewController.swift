//
//  LostViewController.swift
//  Twerk-and-Teach-iOS
//
//  Created by Calvin on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class LostViewController : UIViewController {
    var pOneScore: Int!
    var pTwoScore: Int!
    let client = NSEClient.sharedInstance
    var stream : PaerStream!
    var donation : Double!
    
    override func shouldAutorotate() -> Bool {
        
        return false
        
    }
    
    func postTransfer(amount: Double, description: String, accountId: String) {
        client.setKey("a4063d9a0849a4e4dbe689e8854443a1")
        TransferRequest(block: {(builder:TransferRequestBuilder) in
            builder.requestType = HTTPType.POST
            builder.amount = amount
            builder.transferMedium = TransactionMedium.BALANCE
            builder.description = description
            builder.accountId = "55e94a6bf8d8770528e614e5"
            builder.payeeId = "55ebd3a4f94da70f00395894"
            
        })?.send(completion: {(result) in
            TransferRequest(block: {(builder:TransferRequestBuilder) in
                builder.requestType = HTTPType.GET
                builder.accountId = "55e94a6bf8d8770528e614e5"
            })?.send(completion: {(result:TransferResult) in
            })
            
        })
    }
    
    func getRaspberryPiBalance() -> Int {
        client.setKey("a4063d9a0849a4e4dbe689e8854443a1")
        var account : Account!
        var getOneRequest = AccountRequest(block: {(builder) in
            builder.requestType = HTTPType.GET
            builder.accountId = "55e94a6bf8d8770528e614e5"
        })
        
        getOneRequest?.send({(result) in
            account = result.getAccount()
            print("Account fetched:\(account)\n")
            println("\(account!.balance)")
            
        })
        return account.balance
    }
    
    @IBOutlet var yourScore: UITextField!
    @IBOutlet var theirScore: UITextField!
    var audioPlayer : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name: AnyObject = defaults.valueForKey("bet")
        {
            donation = name as! Double
        }
        var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("6", ofType: "wav")!)
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
        postTransfer(donation, description: "for charity", accountId: "0")
        
        

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueLostToTotal" {

            var dvc = segue.destinationViewController as! TotalAmountViewController
            dvc.stream = stream
            dvc.donator = stream.pOne.username
            dvc.donation = donation
        }
    }

}
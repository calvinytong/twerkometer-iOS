//
//  LostViewController.swift
//  Twerk-and-Teach-iOS
//
//  Created by Calvin on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import UIKit

class LostViewController : UIViewController {
    var pOneScore: Int!
    var pTwoScore: Int!
    let client = NSEClient.sharedInstance
    var stream : PaerStream!
    
    func postTransfer(amount: Double, description: String, accountId: String) {
        client.setKey("a4063d9a0849a4e4dbe689e8854443a1")
        TransferRequest(block: {(builder:TransferRequestBuilder) in
            builder.requestType = HTTPType.POST
            builder.amount = amount
            builder.transferMedium = TransactionMedium.BALANCE
            builder.description = description
            builder.accountId = accountId
            builder.payeeId = "55ebc66bf94da70f0038e5c1"
            
        })?.send(completion: {(result) in
            TransferRequest(block: {(builder:TransferRequestBuilder) in
                builder.requestType = HTTPType.GET
                builder.accountId = accountId
            })?.send(completion: {(result:TransferResult) in
                var transfers = result.getAllTransfers()
                
                if transfers!.count > 0 {
                    let transferToGet = transfers![transfers!.count-1]
                    var transferToDelete:Transfer? = nil;
                    for transfer in transfers! {
                        if transfer.status == "pending" {
                            transferToDelete = transfer
                        }
                    }
                    
                }
            })
            
        })
    }
    
    @IBOutlet var yourScore: UITextField!
    @IBOutlet var theirScore: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        yourScore?.text = "\(pOneScore)"
        theirScore?.text = "\(pTwoScore)"
        postTransfer(0.25, description: "for charity", accountId: "0")
    }
    @IBAction func home(sender: AnyObject) {
        stream.zeroPlayers()
    }
    
}
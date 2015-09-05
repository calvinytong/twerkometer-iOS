//
//  NessieClient.swift
//  Twerk-and-Teach-iOS
//
//  Created by Calvin on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import NessieFmwk

class NessideClient
{
    let client = NSEClient.sharedInstance
    var accountToAccess:Account!
    var accountToPay:Account!
    
    
    init()
    {
        client.setKey("a4063d9a0849a4e4dbe689e8854443a1")
    }
    
    func PostCustomer(firstName: String, lastName: String) {
        CustomerRequest(block: {(builder:CustomerRequestBuilder) in
            builder.requestType = HTTPType.POST
            builder.firstName = firstName
            builder.lastName = lastName
            builder.address = Address(streetName: "streetname", streetNumber: "123", city: "city", state: "DC", zipCode: "12345")
        })?.send({(result) in
            //no result
        })
    }
    
    func AccountPost(name: String) {
        var accountPostRequest = AccountRequest(block: {(builder:AccountRequestBuilder) in
            builder.requestType = HTTPType.POST
            builder.accountType = AccountType.SAVINGS
            builder.balance = 100
            builder.nickname = name
            builder.rewards = 20000
            builder.customerId = "55dd3baef8d87732af4687af"
        })
        
        accountPostRequest?.send({(result:AccountResult) in
            //Should not be any result, should NSLog a message in console saying it was successful
        })
    }
    
    func testPostTransfer(amt: Int) {
        TransferRequest(block: {(builder:TransferRequestBuilder) in
            builder.requestType = HTTPType.POST
            builder.amount = amt
            builder.transferMedium = TransactionMedium.BALANCE
            builder.description = "I lost twerk for tech"
            builder.accountId = self.accountToAccess.accountId
            builder.payeeId = "55e94a1af8d877051ab4f6c1"
            
        })?.send(completion: {(result) in
            TransferRequest(block: {(builder:TransferRequestBuilder) in
                builder.requestType = HTTPType.GET
                builder.accountId = self.accountToAccess.accountId
            })?.send(completion: {(result:TransferResult) in
                var transfers = result.getAllTransfers()
                
                if transfers!.count > 0 {
                    let transferToGet = transfers![transfers!.count-1]
                    var transferToDelete:Transfer? = nil;
                    for transfer in transfers! {
                        if transfer.status == "pending" {
                            transferToDelete = transfer
                            //                            self.testDeleteTransfer(transferToDelete)
                        }
                    }
                    
                    //self.testGetOneTransfer(transferToGet)
                    //self.testPutTransfer(transferToDelete)
                    
                }
            })
            
        })
    }
}
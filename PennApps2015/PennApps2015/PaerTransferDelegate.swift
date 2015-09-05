//
//  PaerTransferDelegate.swift
//  Paer-iOS-2.0
//
//  Created by Aneesh Sachdeva on 8/13/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation

protocol PaerTransferDelegate {
    
    func paerTransferStarted()
    func paerTransferSavedContact(name: String?, success: Bool)
    func paerTransferFollowedTwitter(user: [String : AnyObject]?, success: Bool)
    func paerTransferFollowedInstagram(user: [String : AnyObject]?, success: Bool)
    func paerTransferCompleted()
    func paerTransferIsEmpty() // Nothing shared mutually between the users
    func paerTransferTimedOut() // Not being used currently, networking protocol is not complex enough 
}
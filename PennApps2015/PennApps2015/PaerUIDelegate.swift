//
//  PaerUIDelegate.swift
//  Paer-iOS-2.0
//
//  Created by Aneesh Sachdeva on 8/11/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation

protocol PaerUIDelegate
{
    func paerStarted()
    func paerSavedContact(name: String)
    func paerFollowedTwitter(user: [String : AnyObject])
    func paerFollowedInstagram(user: [String : AnyObject])
    func paerCompleted()
    func paerTimedOut()
}
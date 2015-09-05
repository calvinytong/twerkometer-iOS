//
//  LoginHelper.swift
//  Twerk-and-Teach-iOS
//
//  Created by Calvin on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import Parse
import Bolts

class LoginHelper
{
    init(){}
    
    func registerUser(username : String, password : String, creditcard: String, securitycode: String, expdate: String, completionHandler: (Bool!, NSError!) -> Void)
    {
        var user = PFUser()
        user.username = username
        user.password = password
        user["creditcard"] = creditcard
        user["securitycode"] = securitycode
        user["expdate"] = expdate
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                completionHandler(false, error)
            } else {
                // Hooray! Let them use the app now.
                completionHandler(true, nil)
            }
        }

    }
    
    
    func login(username : String, password: String, completionHandler: (Bool!, NSError!) -> Void)
    {
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                completionHandler(true, nil)
            } else {
                // The login failed. Check error to see why.
                completionHandler(false, error)
            }
        }
    }
}
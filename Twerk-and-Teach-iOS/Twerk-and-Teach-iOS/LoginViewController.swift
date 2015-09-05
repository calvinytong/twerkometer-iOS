//
//  LoginViewController.swift
//  Twerk-and-Teach-iOS
//
//  Created by Calvin on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    var helper = LoginHelper()
    
    var activetextfield : UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        username.tag = 1
        password.tag = 2
        username.delegate = self
        password.delegate = self
    }
    
    @IBAction func login(sender: AnyObject)
    {
        helper.login(username.text, password: password.text, completionHandler: {
            (success: Bool!, error: NSError!) -> Void in
            if success == true
            {
                self.performSegueWithIdentifier("SegueFromLoginToChallenge", sender: self)
            }
            else
            {
                let alert = UIAlertController(title: "Oops!", message: "wrong username or password", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true) { () -> Void in }
            }
        })
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activetextfield = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        switch(textField.tag)
        {
        case 1:
            password.becomeFirstResponder()
            break
        default:
            closeKeyboard()
            login(self)
        }
        return true
    }
    
    func closeKeyboard()
    {
        if(self.activetextfield != nil) {
            self.activetextfield.resignFirstResponder()
            self.activetextfield = nil
        }
    }
}

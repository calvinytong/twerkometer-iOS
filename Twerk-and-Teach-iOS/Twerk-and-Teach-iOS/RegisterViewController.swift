//
//  RegisterViewController.swift
//  Twerk-and-Teach-iOS
//
//  Created by Calvin on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController : UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var ccn: UITextField!
    @IBOutlet weak var securitycode: UITextField!
    @IBOutlet weak var expdate: UITextField!
    
    var helper = LoginHelper()
    
    var activetextfield : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.tag = 1
        password.tag = 2
        ccn.tag = 3
        securitycode.tag = 4
        expdate.tag = 5
        
        username.delegate = self
        password.delegate = self
        ccn.delegate = self
        securitycode.delegate = self
        expdate.delegate = self
    }
    
    //to-do filter for correct input and account correction
    @IBAction func createUser(sender: AnyObject)
    {
        helper.registerUser(username.text, password: password.text, creditcard: ccn.text, securitycode: securitycode.text, expdate: expdate.text, completionHandler: {
            (success: Bool!, error: NSError!) -> Void in
            if success == true
            {
                self.performSegueWithIdentifier("SegueFromRegisterToChallenge", sender: self)
            }
            else
            {
                let alert = UIAlertController(title: "Oops!", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
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
        case 2:
            ccn.becomeFirstResponder()
            break
        case 3:
            securitycode.becomeFirstResponder()
        case 4:
            expdate.becomeFirstResponder()
        default:
            closeKeyboard()
            createUser(self)
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
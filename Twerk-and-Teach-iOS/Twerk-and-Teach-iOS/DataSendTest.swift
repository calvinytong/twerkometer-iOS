//
//  DataSendTest.swift
//  Twerk-and-Teach-iOS
//
//  Created by Calvin on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import UIKit

class DataSendTest : UIViewController
{
    var stream : PaerStream!
    
    @IBOutlet weak var SendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SendData(sender: AnyObject)
    {
        stream.sendData(["hi": "hello"])
    }
    
}
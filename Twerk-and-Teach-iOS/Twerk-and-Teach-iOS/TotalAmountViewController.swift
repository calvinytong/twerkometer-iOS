//
//  TotalAmountViewController.swift
//  Twerk-and-Teach-iOS
//
//  Created by Kevin Hui on 9/6/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import UIKit

class TotalAmountViewController: UIViewController {
    
    var stream : PaerStream!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var donatedAmount: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func home(sender: AnyObject) {
        stream.zeroPlayers()
    }
}
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
    @IBOutlet var yourScore: UITextField!
    @IBOutlet var theirScore: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        yourScore?.text = "\(pOneScore)"
        theirScore?.text = "\(pTwoScore)"
    }

}
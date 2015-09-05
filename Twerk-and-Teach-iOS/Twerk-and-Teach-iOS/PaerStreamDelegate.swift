//
//  PearStreamDelegate.swift
//  Paer-iOS-2.0
//
//  Created by Aneesh Sachdeva on 8/11/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol PaerStreamDelegate {
    func didConnectToStream(stream: PaerStream, success: Bool)
    func didFinishTransfer(stream: PaerStream, friendOffer: [String : AnyObject], success: Bool)
    func didExitStream(stream: PaerStream, success: Bool)
}

//
//  BeaconManager.swift
//  Paer
//
//  Created by Aneesh Sachdeva on 2/15/15.
//  Copyright (c) 2015 Applos. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import CoreLocation
//import AddressBook
import AudioToolbox

class PaerManager : NSObject, CBPeripheralManagerDelegate, CLLocationManagerDelegate, PaerStreamDelegate, PaerTransferDelegate {
    let uuidObject = NSUUID(UUIDString: "ADAC4BC0-8068-463C-B4CB-6CEE98B950A2")
    
    var identifier : String = "bitmachine-twerk"
    
    // emit
    var transmitBeaconRegion = CLBeaconRegion()
    var transmitBeaconData = NSDictionary()
    var transmitBeaconManager = CBPeripheralManager()
    var transmittedData : Bool = false
    
    // range
    var recieveMajor : CLBeaconMajorValue = 0
    var recieveMinor : CLBeaconMinorValue = 0
    var recieveBeaconRegion = CLBeaconRegion()
    var recieveBeaconManager = CLLocationManager() // manages the ranging for iBeacons
    
    //var recievedBeacon : Bool = false
    var recievedPNStream : Bool = false
    var recievedData : Bool = false
    var connectionRecievedMajor : CLBeaconMajorValue = 0
    var connectionRecievedMinor : CLBeaconMinorValue = 0
    
    var paerInProgress : Bool = false
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var dataToSend : [String : AnyObject]!
    
    //var pnHandler : DataConnectionHandler?

    var paerStream : PaerStream!
    var initializedPaerStream : Bool = false
    
    var timeoutTimer : NSTimer!
    var timeoutInterval : Double = 60.0
    
    /** the object which will facilitate the handling of received data */
    var paerTransfer : PaerTransfer!
    
    var delegate : PaerUIDelegate!
    
    /** Variable to keep track of where paering occured -- passed to PaerLog */
    var locationOfPaer : CLLocation = CLLocation()
    
    /**Init with the view that'll be passed along the connection flow, and the dict of info to send.*/
    init(dictToSend : [String : AnyObject]) {
        super.init()

        self.dataToSend = dictToSend
        
        requestAuthorization()
        
        //pnHandler = DataConnectionHandler(view: self.view!, dictionaryToSend: dictToSend)
        println("beacon manager initialized")
    }
    
    //Beacon Magic--------------------------------------------------------------------------------------------------------
    
    /**Method to start paering.*/
    func start() {
        if !paerInProgress
        {
            println("paerInProgress")
            paerInProgress = true
            
            delegate.paerStarted() // this is the very start of the paer
            timeoutTimer = NSTimer.scheduledTimerWithTimeInterval(timeoutInterval, target: self, selector: Selector("timedOut"), userInfo: nil, repeats: false) // Start the timeout countdown
            
            setupBeaconsAndPN()
            
            if !transmitBeaconManager.isAdvertising
            {
                println("transmitting")
                transmitBeacon()
            }
            println("receiving")
            recieveBeacon()
            
            self.recieveBeaconManager.startUpdatingLocation()
        }
    }
    
    /**Method to stop paering and reset to prepare for another paer.*/
    func stopBeacons() {
        timeoutTimer.invalidate() // Stop timeout timer
        
        // Stop ranging and emitting iBeacons
        recieveBeaconManager.stopMonitoringForRegion(recieveBeaconRegion)
        if transmitBeaconManager.isAdvertising
        {
            transmitBeaconManager.stopAdvertising()
        }
        
        initializedPaerStream = false
        paerInProgress = false
    }
    
    /**Set up iBeacon and the PubNub helper (DataConnectionHandler).*/
    func setupBeaconsAndPN()
    {
        let transmitMajor = CLBeaconMajorValue(randomMajorOrMinor())
        let transmitMinor = CLBeaconMajorValue(randomMajorOrMinor())
        
        self.transmitBeaconRegion = CLBeaconRegion(proximityUUID: uuidObject, major: transmitMajor, minor: transmitMinor, identifier: identifier)
        
        self.recieveBeaconManager.delegate = self
        
        self.recieveBeaconRegion = CLBeaconRegion(proximityUUID: uuidObject, identifier: identifier)
        
    }
    
    func requestAuthorization()
    {
        if NSProcessInfo().operatingSystemVersion.majorVersion >= 8
        {
            if self.recieveBeaconManager.respondsToSelector("requestWhenInUseAuthorization")
            {
                self.recieveBeaconManager.requestWhenInUseAuthorization()
                println("authorization requested")
            }
        }
        else
        {
            println("Must have iOS 8+")
        }

    }
    
    /**Emitt iBeacon.*/
    func transmitBeacon()
    {
        self.transmitBeaconData = self.transmitBeaconRegion.peripheralDataWithMeasuredPower(nil)
        self.transmitBeaconManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    /**Start monitoring for other iBeacons*/
    func recieveBeacon()
    {
        self.recieveBeaconManager.startMonitoringForRegion(self.recieveBeaconRegion)
    }
    
    /**Keeps track of the bluetooth state.*/
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if peripheral.state == CBPeripheralManagerState.PoweredOn
        {
            self.transmitBeaconManager.startAdvertising(transmitBeaconData as [NSObject : AnyObject])
            println("Powered On, Transmitting")
        }
        else if peripheral.state == CBPeripheralManagerState.PoweredOff
        {
            self.transmitBeaconManager.stopAdvertising()
            println("Powered off, Stopped transmitting")
        }
    }
    
    //iBeacon delegate events-----------------------------------------------------------------------------------------------------
    
    /**Triggered when iBeacon ranging begins*/
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        // ensure we detect beacons that are already in range
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion) // testing line
        
        //println("did start monitoring for region: \(region)")
        
        // TODO: Start animation for showing ranging progress
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println(error)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    /**This is where the magic happens. Here is the data of all the ranged beacons with proximitiy values.*/
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        println("i ranged a beacon")
        if beacons.count == 0
        {
            return
        }
        
        let beacon = beacons.last as! CLBeacon
        
        if (beacon.major != self.transmitBeaconRegion.major || beacon.minor != self.transmitBeaconRegion.minor)
        {
            if beacon.proximity == CLProximity.Unknown
            {
                println("Proximity Unknown")
                return
            }
            else if beacon.proximity == CLProximity.Far
            {
                println("Proximity Far \(beacon.major) : \(beacon.minor)")
            }
            else if beacon.proximity == CLProximity.Near
            {
                println("Proximity Near \(beacon.major) : \(beacon.minor)")
            }
            else if beacon.proximity == CLProximity.Immediate
            {
                //println("Proximity Immediate \(beacon.major) : \(beacon.minor)")
                
                if !initializedPaerStream
                {
                    paerStream = PaerStream(localMajor: Int(self.transmitBeaconRegion.major), localMinor: Int(self.transmitBeaconRegion.minor), foreignMajor: Int(beacon.major), foreignMinor: Int(beacon.minor))
                    
                    initializedPaerStream = true
                    
                    paerStream.delegate = self
                    
                    // yay magic, let's save the location for the PaerLog
                    locationOfPaer = manager.location
                }
            }
        }
        else
        {
            println("Recieved phone's own beacon.")
        }
    }
    
    //End Beacon Magic---------------------------------------------------------------------------------------------------------
    
    //Delegate Work------------------------------------------------------------------------------------------------------------
    
    // PaerStream delegate
    func didConnectToStream(stream: PaerStream, success: Bool) {
        println("Connected to stream")
    }
    
    func didFinishTransfer(stream: PaerStream, friendOffer: [String : AnyObject], success: Bool) {
        println("Transfer finished")
        println("Received dict: \(friendOffer)")
        
        // proccess the data and connect to friend's networks / contact
        paerTransfer = PaerTransfer(userOffer: dataToSend, friendOffer: friendOffer)
        paerTransfer.delegate = self
        
        stopBeacons() // No need for beacons now
    }
    
    func didExitStream(stream: PaerStream, success: Bool) {
        println("Exited stream")
        
        paerStream = nil // Done with stream, erase for saftey
        
        // TODO: Move this to when the actual processing of data is completed (needs Calvin's code)
        //delegate.paerCompleted() // Done with paering!
    }
    
    // Called when the timeoutTimer finishes
    func timedOut()
    {
        stopBeacons()
        
        delegate.paerTimedOut()
    }
    
    //PaerTransfer delegate
    
    func paerTransferStarted() {
        
    }
    
    func paerTransferFollowedInstagram(user: [String : AnyObject]?, success: Bool) {
        if user != nil
        {
            delegate.paerFollowedInstagram(user!)
        }
    }
    
    func paerTransferFollowedTwitter(user: [String : AnyObject]?, success: Bool) {
        if user != nil
        {
            delegate.paerFollowedTwitter(user!)
        }
    }
    
    func paerTransferSavedContact(name: String?, success: Bool) {
        
    }
    
    func paerTransferCompleted() {
        
    }
    
    func paerTransferIsEmpty() {
        
    }
    
    func paerTransferTimedOut() {
        
    }
    
    //End Delegate Work----------------------------------------------------------------------------------------------------------
    
    //Misc.----------------------------------------------------------------------------------------------------------------------
    
    /**Generate a random major and minor*/
    func randomMajorOrMinor() -> UInt16
    {
        var num : Int = Int(arc4random_uniform(65535 + 1))
        return UInt16(num)
    }
    
    /** Return location of paering */
    func getLocationOfPaer() -> CLLocation
    {
        return locationOfPaer
    }
}

//
//  PaerStream.swift
//  Paer-iOS-2.0
//
//  Created by Aneesh Sachdeva on 8/11/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import PubNub

class PaerStream: NSObject, PNObjectEventListener
{
    var client : PubNub!
    
    let config = PNConfiguration(publishKey: "pub-c-ae1d1e9e-6147-460b-bea0-2fa7e75c105b", subscribeKey: "sub-c-69ac7426-3fab-11e5-b66d-02ee2ddab7fe")
    
    var localMinor : Int!
    var localMajor : Int!
    var foreignMinor : Int!
    var foreignMajor : Int!
    var joinedChannel : Bool = false
    var channelName : String = ""
    var twousersinchannel : Bool = false
    var uuid : String!
    var dataToSend : [String: AnyObject] = Dictionary<String, AnyObject>()
    

    
    var pOne : player = player()
    var pTwo : player = player()
    
    var delegate : PaerStreamDelegate!
    
    /**Connect to PubNub and prepare the class channel setup.*/
    init(localMajor: Int, localMinor: Int, foreignMajor: Int, foreignMinor: Int) {
        super.init()
        
        client = PubNub.clientWithConfiguration(config)
        client.addListener(self)
        
        self.localMajor = localMajor
        self.localMinor = localMinor
        self.foreignMajor = foreignMajor
        self.foreignMinor = foreignMinor
        self.uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        
        formChannelName()
        
        client.subscribeToChannels([channelName], withPresence: true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pOneIncrement:", name: "pOneIncrement", object: nil)
    }
    
    /**Send data over channel.*/
    func sendData(dataToSend :  Dictionary<String, AnyObject>)
    {
        self.dataToSend = dataToSend
        self.dataToSend["uuid"] = self.uuid
        
        if dataToSend["type"] as! String == "start"
        {
            self.pOne.ready = 1
        }
        else if dataToSend["type"] as! String == "finish"
        {
            pOne.finished = 1
        }
        
        if self.pOne.ready + self.pTwo.ready == 2
        {
        NSNotificationCenter.defaultCenter().postNotificationName("ready", object: nil)
        }
        
        client.publish(self.dataToSend, toChannel: channelName, compressed: false, withCompletion: {
            (status: PNPublishStatus!) -> Void in
            
            if !status.error
            {
                println("Successfully transmitted data!")
            }
            else // Something failed
            {
                println("Error sending PN message: \(status.errorData)")
            }
        })
    }
    
    
    /**Handle receiving messages over the channel. We filter only for messages not sent by us.*/
    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        
            // Ensure we're on the correct channel
        if message.data.subscribedChannel == channelName
        {
            let messageData = message.data.message as! Dictionary<String, AnyObject>
            println("Received message: \(messageData)")
            
            //message came from other
            if messageData["uuid"] as? String != self.uuid
            {
                var pTwoScore : Int!
                switch(messageData["type"] as! String)
                {
                    case "start":
                        pTwo.ready = 1
                        if pOne.ready + pTwo.ready == 2
                        {
                            NSNotificationCenter.defaultCenter().postNotificationName("ready", object: nil)
                        }
                        return
                    case "incrementPTwo":
                        pTwo.score++
                        return
                    case "finish":
                        pTwo.score = messageData["score"] as! Int
                        pTwo.finished = 1
                        if pOne.finished + pTwo.finished == 2
                        {
                            
                            NSNotificationCenter.defaultCenter().postNotificationName("finished", object: [pOne.score, pTwo.score])
                        }
                        return
                    
                    default:
                        return
                }
            }
            else
            {
                return
            }
            
            //do what we want with messageData
            
        }
    }
    
    /**PubNub client received a presence event on a subscribed channel.*/
    func client(client: PubNub!, didReceivePresenceEvent event: PNPresenceEventResult!) {
        
        if event.data.subscribedChannel == channelName // Ensure we're on the correct channel
        {
            println("Received presence event on transmit channel: \(event.data.presenceEvent)")
            if event.data.presenceEvent == "join"
            {
                // Check the users on the channel
                client.hereNowForChannel(channelName, withCompletion: {
                    (result: PNPresenceChannelHereNowResult!, error: PNErrorStatus!) -> Void in
                    
                    if error == nil
                    {
                        if result.data.occupancy == 2
                        {
                            println("result.data.uuids: \(result.data.uuids)")
                            self.twousersinchannel = true
                            
//                            if !self.sentData
//                            {
//                                self.sendData() // there are now two unique users in the channel, send data
//                            }
                        }
                    }
                    else // Something failed
                    {
                        println("Error getting here now for transmit channel: \(error.errorData)")
                    }
                })
            }
            else if event.data.presenceEvent == "leave"
            {
                twousersinchannel = false
            }
        }
    }
    
    /**Handle PubNub status change events.*/
    func client(client: PubNub!, didReceiveStatus status: PNSubscribeStatus!) {
        if status.category == PNStatusCategory.PNConnectedCategory
        {
            // Connect event. You can do stuff like publish, and know you'll get it.
            // Or just use the connected event to confirm you are subscribed for
            // UI / internal notifications, etc
            
            println("Connected to channel with data: \(status.data)")
            
            joinedChannel = true
            
            delegate.didConnectToStream(self, success: true)
        }
        else if status.category == PNStatusCategory.PNDisconnectedCategory
        {
            delegate.didExitStream(self, success: true)
        }
        else if status.category == PNStatusCategory.PNUnexpectedDisconnectCategory
        {
            // This event happens when radio / connectivity is lost
        }
        else if status.category == PNStatusCategory.PNReconnectedCategory
        {
            // Happens as part of our regular operation. This event happens when
            // radio / connectivity is lost, then regained.
        }
        else if status.category == PNStatusCategory.PNDecryptionErrorCategory
        {
            // Handle messsage decryption error. Probably client configured to
            // encrypt messages and on live data feed it received plain text.
        }
    }
    
    
    func formChannelName()
    {
        var ids : [Int] = [localMajor, localMinor, foreignMajor, foreignMinor]
        ids.sort(<)
        println("ids: \(ids)")
        
        for id in ids
        {
            channelName += String(id)
        }
        println("Channel name: \(channelName)")
    }
    
    func pOneIncrement(notification: NSNotification)
    {
        pOne.score = notification.object as! Int
    }
}

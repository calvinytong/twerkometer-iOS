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
    
    var dataToSend : [String : AnyObject] = Dictionary<String, AnyObject>()
    var sentData : Bool = false
    var receivedData : Bool = false
    var friendOffer : [String : AnyObject] = Dictionary<String, AnyObject>() // The received data
    
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
        
        formChannelName()
        
//        dataToSend = data
//        dataToSend["uuid"] = client.uuid() // sign the message with sender id
        
        client.subscribeToChannels([channelName], withPresence: true)
    }
    
    /**Send data over channel.*/
    func sendData(dataToSend : [String: AnyObject])
    {
        client.publish(dataToSend, toChannel: channelName, compressed: false, withCompletion: {
            (status: PNPublishStatus!) -> Void in
            
            if !status.error
            {
                println("Successfully transmitted data!")
                
                self.sentData = true
                
                self.checkTransferStatus() // check to see if transfer is completed
            }
            else // Something failed
            {
                println("Error sending PN message: \(status.errorData)")
            }
        })
    }
    
    /**Handle receiving messages over the channel. We filter only for messages not sent by us.*/
    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        
        if !receivedData
        {
            // Ensure we're on the correct channel
            if message.data.subscribedChannel == channelName
            {
                let messageData : AnyObject = message.data.message
                

                println("Received message: \(messageData)")
                        
                        
                receivedData = true
                        
                checkTransferStatus() // check to see if transfer is completed
        
            }
        }
    }
    
    /**PubNub client received a presence event on a subscribed channel.*/
    func client(client: PubNub!, didReceivePresenceEvent event: PNPresenceEventResult!) {
        
        if event.data.subscribedChannel == channelName // Ensure we're on the correct channel
        {
            println("Received presence event on transmit channel: \(event.data.presenceEvent)")
//            if event.data.presenceEvent == "join"
//            {
//                // Check the users on the channel
//                client.hereNowForChannel(channelName, withCompletion: {
//                    (result: PNPresenceChannelHereNowResult!, error: PNErrorStatus!) -> Void in
//                    
//                    if error == nil
//                    {
//                        if result.data.occupancy == 2
//                        {
//                            println("result.data.uuids: \(result.data.uuids)")
//                            
//                            if !self.sentData
//                            {
//                                self.sendData() // there are now two unique users in the channel, send data
//                            }
//                        }
//                    }
//                    else // Something failed
//                    {
//                        println("Error getting here now for transmit channel: \(error.errorData)")
//                    }
//                })
//            }
//            else if event.data.presenceEvent == "leave"
//            {
//
//            }
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
    
    func checkTransferStatus()
    {
        if sentData && receivedData
        {
            delegate.didFinishTransfer(self, friendOffer: friendOffer, success: true)
            
            client.unsubscribeFromChannels([channelName], withPresence: true) // We're done! Leave channel
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
    

}

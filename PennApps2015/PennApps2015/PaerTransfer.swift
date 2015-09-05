//
//  Paer.swift
//  Paer-iOS-2.0
//
//  Created by Aneesh Sachdeva on 8/13/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation

class PaerTransfer: NSObject
{
    var mutualItems : [String : AnyObject] = Dictionary<String, AnyObject>()
    
    var delegate : PaerTransferDelegate!
    
    /**Initialize transfer object by passing in the offers from both users, and then finding mutuality between them.*/
    init(userOffer: [String : AnyObject], friendOffer: [String : AnyObject]) {
        super.init()
        
        mutualItems = getMutualItems(userOffer, friendOffer: friendOffer)
    }
    
    /**Discover the mutual offers between the two dicts and then return a dict containing the values for the mutual keys of the friend's offer.*/
    func getMutualItems(userOffer: [String : AnyObject], friendOffer: [String : AnyObject]) -> [String : AnyObject]
    {
        // find the union of the two dicts through their keys (mutuality testing)
        let receivedKeys : [String] = Array(friendOffer.keys)
        let sentKeys : [String] = Array(userOffer.keys)
        var _mutualItems : [String : AnyObject] = Dictionary<String, AnyObject>()
        
        let receivedSet : NSMutableSet = NSMutableSet(array: receivedKeys)
        let sentSet : NSSet = NSSet(array: sentKeys)
        if receivedSet.intersectsSet(sentSet as Set<NSObject>)
        {
            receivedSet.intersectSet(sentSet as Set<NSObject>)
        }
        else
        {
            // Well fuck, edge case..
            // Find a good way to give the user feedback
            
            delegate.paerTransferIsEmpty()
        }
        
        // create the final dict using the mutual keys
        let mutualKeys = Array(receivedSet)
        var finishedDict  : [String : AnyObject] = Dictionary<String, AnyObject>()
        
        for key in mutualKeys
        {
            //let keyStr : String = key as String
            _mutualItems[key as! String] = friendOffer[key as! String]
        }
        
        return _mutualItems
    }
}
//
//  twerkClass.swift
//  PennApps2015
//
//  Created by Kevin Hui on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import CoreMotion

class twerkClass {
    
    //Instance Variables
    var shakeCount: Int = 0
    var twerkVectorArray: [Double] = []
    var timeRemaining: Int = 10
    var timer = NSTimer()
    
    var stop = false
    var twerkMotionManager = CMMotionManager()
    var datastream : PaerStream!
    
    init(stream : PaerStream) {
        datastream = stream
    }
    
    func outputAccelerationData(acceleration: CMAcceleration) {
        var x = acceleration.x
        var y = acceleration.y
        var z = acceleration.z
        
        var twerkVector = sqrt(x*x + y*y + z*z)
        
        
        twerkVectorArray.append(twerkVector)
        
        
        if (twerkVector > 1.5) {
            shakeCount++
            datastream.sendData(["type": "incrementPTwo"])
            NSNotificationCenter.defaultCenter().postNotificationName("pOneIncrement", object: shakeCount)
        }
        if (stop) {
            twerkMotionManager.stopAccelerometerUpdates()
            
        }
    }
}
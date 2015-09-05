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
    var currentMaxAccelX: Double = 0.0
    var currentMaxAccelY: Double = 0.0
    var currentMaxAccelZ: Double = 0.0
    var shakeCount: Int = 0
    
    var timeRemaining: Int = 10
    var timer = NSTimer()
    
    var stop = false
    var twerkMotionManager = CMMotionManager()
    
    
    func outputAccelerationData(acceleration: CMAcceleration) {
        var x = acceleration.x
        var y = acceleration.y
        var z = acceleration.z
        
        if (sqrt(x*x + y*y + z*z) > 1.5) {
            shakeCount++
        }
        if (stop) {
            twerkMotionManager.stopAccelerometerUpdates()
        }
    }
}
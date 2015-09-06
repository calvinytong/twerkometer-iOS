//
//  twerkClass.swift
//  PennApps2015
//
//  Created by Kevin Hui on 9/5/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import CoreMotion
import Darwin

class twerkClass {
    
    //Instance Variables
    var shakeCount: Int = 0
    var twerkVectorArray: [Double] = []
    var timeRemaining: Int = 10
    var timer = NSTimer()
    
    var stop = false
    var twerkMotionManager = CMMotionManager()
    var datastream : PaerStream!
    
    var stdv : Double = 0.0
    
    init(stream : PaerStream) {
        datastream = stream
    }
    
//    func standardDeviation(twerkArray: [Double]) -> Double {
//        var indicesArray: [Int] = []
//        for x in 0...(twerkArray.count - 1) {
//            if twerkArray[x] > 1.5 {
//                indicesArray.append(x)
//            }
//        }
//        var differenceArray: [Int] = []
//        for y in 1...(indicesArray.count - 1) {
//            differenceArray.append(indicesArray[y] - indicesArray[y-1])
//        }
//        
//        
//        for z in differenceArray {
//            stdv += Double(z*z)
//        }
//        
//        return sqrt(stdv)
//    }
    
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
//            stdv = standardDeviation(twerkVectorArray)
        }
    }
}
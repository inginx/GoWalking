//
//  RunningData.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/27.
//  Copyright © 2015年 称一称. All rights reserved.
//


class RunningData: NSObject {
    var locations: NSMutableArray! = []
    var startTime:NSDate!
    var endTime:NSDate!
    var distance:Double = 0
    var seconds:Int! = 0
    var kind:RunningType!
    var steps:Int!
    
    override init() {

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.locations = aDecoder.decodeObjectForKey("locations")  as! NSMutableArray
        self.startTime = aDecoder.decodeObjectForKey("startTime")as! NSDate
        self.endTime = aDecoder.decodeObjectForKey("endTime")  as! NSDate
        self.distance = aDecoder.decodeObjectForKey("distance")  as! Double
        self.seconds = aDecoder.decodeObjectForKey("seconds")  as! Int
        self.steps = aDecoder.decodeObjectForKey("steps")  as! Int
        self.kind = RunningType(rawValue: aDecoder.decodeIntegerForKey("kind") )
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(self.locations, forKey: "locations")
        aCoder.encodeObject(self.endTime, forKey: "endTime")
        aCoder.encodeObject(self.startTime, forKey: "startTime")
        aCoder.encodeObject(self.distance, forKey: "distance")
        aCoder.encodeObject(self.seconds, forKey: "seconds")
        aCoder.encodeInteger(self.kind.rawValue, forKey: "kind")
        aCoder.encodeObject(self.steps, forKey: "steps")

    }

}

enum RunningType:Int{
    case walking = 0
    case runing = 1
    case cycling = 2
}

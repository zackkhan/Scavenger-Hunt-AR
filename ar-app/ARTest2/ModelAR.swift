//
//  ModelAR.swift
//  ARTest2
//
//  Created by Tamer on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ModelAR
{
    var name:String?
    var x: Float?
    var y: Float?
    var z: Float?
    
    static let PENGUIN = ModelAR(name: "art.scnassets/badtz.obj", x: 0.025, y: 0.025, z: 0.025)
    static let SUNGLASSES = ModelAR(name: "art.scnassets/glasses.scn", x: 0.5, y: 0.5, z: 0.5)
    static let SOCCER = ModelAR(name: "art.scnassets/soccer.scn", x: 0.002, y: 0.002, z: 0.002)
    static let BALL = ModelAR(name: "art.scnassets/red-ball.scn", x: 0.2, y: 0.2, z: 0.2)
    
    init(name: String, x: Float, y: Float, z: Float) {
        self.name = name
        self.x = x
        self.y = y
        self.z = z
    }
    
}

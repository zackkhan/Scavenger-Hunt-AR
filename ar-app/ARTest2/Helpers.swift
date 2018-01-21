//
//  Helpers.swift
//  ARTest2
//
//  Created by MetroStar on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation

func getRandomValue (lower:Float, upper:Float) -> Float{
    let arc4randoMax:Double = 0x100000000
    let ab = (Double(arc4random()) / arc4randoMax)
    return Float(ab) * (upper - lower) + lower
}

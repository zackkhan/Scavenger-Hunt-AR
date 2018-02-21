//
//  Extension+SNNode.swift
//  ARTest2
//
//  Created by MetroStar on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import ARKit

extension SCNNode {
    static func buildFromJson(jsonObject: [String: Any]) -> SCNNode? {
        let modelNum: Int = jsonObject["modelNum"] as! Int
        if (modelNum >= 0 && modelNum < 4) {
            let model: Model = Model(rawValue: modelNum)!
            let xCoordinate: Float = jsonObject["x"] as! Float
            let yCoordinate: Float = jsonObject["y"] as! Float
            let zCoordinate: Float = jsonObject["z"] as! Float
            
            var mObj: ModelAR? = nil
            
            
            switch model {
            case .Ball:
                mObj = ModelAR.BALL
            case .Soccer:
                mObj = ModelAR.SOCCER
            case .Sunglass:
                mObj = ModelAR.SUNGLASSES
            case .Penguin:
                mObj = ModelAR.PENGUIN
            }
            
            let currNode:SCNNode = SCNNode()
            let geoScene = SCNScene(named: mObj!.name!)
            let nodeArray = geoScene!.rootNode.childNodes
            for childNode in nodeArray {
                currNode.addChildNode(childNode as SCNNode)
            }
            currNode.scale = SCNVector3(x: mObj!.x!, y: mObj!.y!, z: mObj!.z!)
            currNode.position = SCNVector3(xCoordinate, yCoordinate, zCoordinate)
            return currNode
        } else {
            return nil
        }
        
        
    }
    
    static func buildFromParams(modelNum:Int, x: Float, y: Float, z: Float) -> SCNNode {
        var mObj: ModelAR? = nil
        let model: Model = Model(rawValue: modelNum)!

        switch model {
        case .Ball:
            mObj = ModelAR.BALL
        case .Soccer:
            mObj = ModelAR.SOCCER
        case .Sunglass:
            mObj = ModelAR.SUNGLASSES
        case .Penguin:
            mObj = ModelAR.PENGUIN
        }
        
        let currNode:SCNNode = SCNNode()
        let geoScene = SCNScene(named: mObj!.name!)
        let nodeArray = geoScene!.rootNode.childNodes
        for childNode in nodeArray {
            currNode.addChildNode(childNode as SCNNode)
        }
        currNode.scale = SCNVector3(x: mObj!.x!, y: mObj!.y!, z: mObj!.z!)
        currNode.position = SCNVector3(x, y, z)
        return currNode
        
    }
}

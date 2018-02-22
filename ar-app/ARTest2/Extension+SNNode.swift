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
        // let model: Model = Model(rawValue: modelNum)!
        let xCoordinate: Float = jsonObject["x"] as! Float
        let yCoordinate: Float = jsonObject["y"] as! Float
        let zCoordinate: Float = jsonObject["z"] as! Float
        
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(xCoordinate, yCoordinate, zCoordinate)
        
        let material = SCNMaterial()
        switch(modelNum) {
        case 0:
            material.diffuse.contents = UIColor.yellow
            break
        case 1:
            material.diffuse.contents = UIColor.red
            break
        case 2:
            material.diffuse.contents = UIColor.blue
            break
        case 3:
            material.diffuse.contents = UIColor.green
            break
        default:
            material.diffuse.contents = UIColor.green
        }
        box.materials = [material]
        
        return boxNode
        /*
         var mObj: ModelAR? = nil
         
         
         switch model {
         case .Penguin:
         mObj = ModelAR.PENGUIN
         case .Ball:
         mObj = ModelAR.BALL
         case .Soccer:
         mObj = ModelAR.SOCCER
         case .Sunglass:
         mObj = ModelAR.SUNGLASSES
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
         */
        
        
        
    }
    
    static func buildFromJson2(jsonObject: [String: Any]) -> SCNNode? {
        let modelNum: Int = jsonObject["modelNum"] as! Int
        // let model: Model = Model(rawValue: modelNum)!
        let xCoordinate: Float = jsonObject["x"] as! Float
        let yCoordinate: Float = jsonObject["y"] as! Float
        let zCoordinate: Float = jsonObject["z"] as! Float
        var mObj: ModelAR = ModelAR.PENGUIN
        
        let currNode:SCNNode = SCNNode()
        let geoScene = SCNScene(named: mObj.name!)
        let nodeArray = geoScene!.rootNode.childNodes
        for childNode in nodeArray {
            currNode.addChildNode(childNode as SCNNode)
        }
        currNode.scale = SCNVector3(x: mObj.x!, y: mObj.y!, z: mObj.z!)
        currNode.position = SCNVector3(xCoordinate, yCoordinate, zCoordinate)
        return currNode
    }
    
    static func buildFromParams(modelNum:Int, x: Float, y: Float, z: Float) -> SCNNode {
        var mObj: ModelAR? = nil
        let model: Model = Model(rawValue: modelNum)!
        
        switch model {
        case .Penguin:
            mObj = ModelAR.PENGUIN
        case .Ball:
            mObj = ModelAR.BALL
        case .Soccer:
            mObj = ModelAR.SOCCER
        case .Sunglass:
            mObj = ModelAR.SUNGLASSES
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

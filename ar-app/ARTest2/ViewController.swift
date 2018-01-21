//
//  ViewController.swift
//  TestAR
//
//  Created by Zack  on 1/19/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import ARKit
import SwiftSpinner
class ViewController: UIViewController
{    
    @IBOutlet weak var sceneView: ARSCNView!
    private var didDropTarget: Bool = false
    
    func createGameMap() {
        for index in 0 ... AppData.propsDict.count {
            var currProp = AppData.propsDict[index]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
       /* switch AppData.currPlayerType {
        case .Host:
            print("Host")
        case .Player:
            loadGameMap()
        }*/
        
        /*if AppData.currPlayerType == PlayerType.Host {
        for i in 1...1000 {
            let r_x = getRandomValue(lower: -3.0, upper: 5.0), r_y = getRandomValue(lower: -3.0, upper: 5.0),
            r_z = getRandomValue(lower: -3.0, upper: 5.0)
            let random_color = Int(arc4random_uniform(4))
            addBox(x: r_x, y: r_y, z: r_z, color: random_color, index: i)
        }
        // Host sends signal now
            var dataDict: [PlayerMessages:[Int: SCNNode]] = [:]
            dataDict[PlayerMessages.InitialGameHash] = AppData.nodeDict
            //let data = NSKeyedArchiver.archivedData(withRootObject: dataDict)
            var messageHash: [String: Any] = [:]
            messageHash["model"] = 1
            messageHash["x"] = Float(2)
            messageHash["y"] = Float(3)
            messageHash["z"] = Float(4)
            
            let data = NSKeyedArchiver.archivedData(withRootObject: messageHash)
            MPCServiceManager.sharedInstance.sendToPlayers(message: data)
    }*/
      
    }
    
    private func initialize() {
        if AppData.currPlayerType == PlayerType.Host {
            loadGameMap()
        } else {
                SwiftSpinner.show("Waiting for Host to Hide Object...")
        }
        addTapGestureToSceneView()
        AppData.CurrentViewController = self
    }
    
    func loadGameMap() {
        for map in AppData.nodeDict {
            let index:Int = map.key
            sceneView.scene.rootNode.addChildNode(map.value)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    
    /*func addModel(x: Float = 0, y: Float = 0, z: Float = -0.2, modelNum:Int, Index: Int) {
        let node = SCNNode()
        var mObj:ModelAR? = nil
        switch (modelNum) {
            case 0:
                mObj = ModelAR.PENGUIN
                break;
            case 1:
                mObj = ModelAR.SUNGLASSES
                break;
            case 2:
                mObj = ModelAR.SOCCER
                break;
            case 3:
                mObj = ModelAR.BALL
                break;
            default:
                return
        }
        let geoScene = SCNScene(named: mObj!.name!)
        let nodeArray = geoScene!.rootNode.childNodes
        for childNode in nodeArray {
            node.addChildNode(childNode as SCNNode)
        }
        node.scale = SCNVector3(x: mObj!.x!, y: mObj!.y!, z: mObj!.z!)
        node.position = SCNVector3(x, y, z)
        AppData.nodeDict[Index] = node
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2, color:Int = 1, index:Int) {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(x, y, z)
        
        let material = SCNMaterial()
        switch(color) {
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
    
        print("values")
        print(x)
        print(y)
        print(z)
        
        AppData.nodeDict[index] = boxNode
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    func sendPropsDict() {
        for prop in AppData.propsDict {
            let data = NSKeyedArchiver.archivedData(withRootObject: prop)
            MPCServiceManager.sharedInstance.sendToPlayers(message: data)
        }
    }
    
    @IBAction func onSend(_ sender: UIButton) {
        var messageHash: [String: Any] = [:]
        messageHash["model"] = 1
        messageHash["x"] = Float(2)
        messageHash["y"] = Float(3)
        messageHash["z"] = Float(4)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: messageHash)
        MPCServiceManager.sharedInstance.sendToPlayers(message: data)
    }*/
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        
        if (AppData.currPlayerType == .Host && !didDropTarget) {
            let tapLocation = recognizer.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(tapLocation)
            
            guard let node = hitTestResults.first?.node else {
                    let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
                    if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                        let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                        Socket.sharedInstance.addTargetObject(modelNum: Int(arc4random_uniform(4)), x: translation.x, y: translation.y, z: translation.z)
                    }
                return
            }
        } else if (AppData.currPlayerType == .Player) {
            let tapLocation = recognizer.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(tapLocation)
            guard let node = hitTestResults.first?.node else {
                return
            }
            for (key, value) in AppData.nodeDict {
                if (value == node) {
                    // send the key to delete
                    Socket.sharedInstance.sendDeleteEmit(index: key)
                }
            }
            node.removeFromParentNode()
            
        }        
        
        
    }
    
    override func onGetData(message: String) {
        print("Hello")
    }
    
    override func addNode(node: SCNNode) {
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    
}

extension ViewController: MPCServiceManagerDelegate {
    func startedGame(manager: MPCServiceManager) {
    }
    
    func playerGotReady(manager: MPCServiceManager, player: String) {
        
    }
    
    func connectedDeviceChanged(manager: MPCServiceManager, connectedDevices: [String]) {
        if (connectedDevices.count > 0) {
            
        }
    }
    
    func valueChanged(manager: MPCServiceManager, message: String) {
        print("Value Changed")
    }
    
    
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}



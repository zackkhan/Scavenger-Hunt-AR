//
//  ViewController.swift
//  TestAR
//
//  Created by Zack  on 1/19/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import ARKit

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
      
    }
    
    private func initialize() {
        if AppData.currPlayerType == PlayerType.Host {
            loadGameMap()
        } else {
            if (Thread.isMainThread) {
                print("IM on the MAIN Thread")
            } else {
                print("Im on Background")
            }
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
                        let modelNum: Int = 0
                        let x:Float = translation.x
                        let y: Float = translation.y
                        let z: Float = translation.z
                        Socket.sharedInstance.addTargetObject(modelNum: modelNum, x: x, y: y, z: z)
                        let node:SCNNode = SCNNode.buildFromParams(modelNum: modelNum, x: x, y: y, z: z)
                        didDropTarget = true
                        OperationQueue.main.addOperation {
                            self.sceneView.scene.rootNode.addChildNode(node)
                        }
                    }
                return
            }
        } else if (AppData.currPlayerType == .Player) {
            let tapLocation = recognizer.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(tapLocation)
            guard let node = hitTestResults.first?.node else {
                return
            }
            
            if (node.worldPosition.x == AppData.hostObjectNode?.position.x && node.worldPosition.y == AppData.hostObjectNode?.position.y && node.worldPosition.z == AppData.hostObjectNode?.position.z){
                Socket.sharedInstance.sendWinEmit()
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC: ResultViewController = segue.destination as! ResultViewController
        
    }
    
    
}


extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}



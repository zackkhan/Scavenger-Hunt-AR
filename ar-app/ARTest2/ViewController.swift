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
    var nodeDict:[Int: SCNNode] = [:]
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    func getRandomValue (lower:Float, upper:Float) -> Float{
        let arc4randoMax:Double = 0x100000000
        let ab = (Double(arc4random()) / arc4randoMax)
        return Float(ab) * (upper - lower) + lower
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addBox()
        addTapGestureToSceneView()
        
        for i in 1...100 {
            let r_x = getRandomValue(lower: -3.0, upper: 5.0), r_y = getRandomValue(lower: -3.0, upper: 5.0),
            r_z = getRandomValue(lower: -3.0, upper: 5.0)
            let random_color = Int(arc4random_uniform(4))
            addModel(x: r_x, y: r_y, z: r_z, index: i % 4)
        }
        // Host sends signal now
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
    
    func addModel(x: Float = 0, y: Float = 0, z: Float = -0.2, index:Int) {
        let node = SCNNode()
        var mObj:ModelAR? = nil
        switch (index) {
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
        
        nodeDict[index] = boxNode
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else {
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                // addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode()
    }
}
extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}


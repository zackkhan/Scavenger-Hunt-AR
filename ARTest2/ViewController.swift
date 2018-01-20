//
//  ViewController.swift
//  TestAR
//
//  Created by Zack  on 1/19/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
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
        
        for index in 1...1000 {
            let r_x = getRandomValue(lower: -3.0, upper: 5.0), r_y = getRandomValue(lower: -3.0, upper: 5.0),
            r_z = getRandomValue(lower: -3.0, upper: 5.0)
            let random_color = Int(arc4random_uniform(4))
            addBox(x: r_x, y: r_y, z: r_z, color: random_color)
        }
        // Do any additional setup after loading the view, typically from a nib.
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
    
    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2, color:Int = 1) {
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
                addBox(x: translation.x, y: translation.y, z: translation.z)
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


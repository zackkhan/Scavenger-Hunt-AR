//
//  Extension+UIViewController.swift
//  ARTest2
//
//  Created by MetroStar on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit
import ARKit

protocol Listener {
    func onGetData(message:String)
    func addNode(node: SCNNode)
}
extension UIViewController {
    @objc func addNode(node: SCNNode) {
        print("Adding Node")
    }
    
    @objc func onGetData(message: String) {
        print("Got Data of \(message)")
    }
    
    
}

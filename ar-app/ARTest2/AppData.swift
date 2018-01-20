//
//  AppData.swift
//  ARTest2
//
//  Created by Tamer Bader on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import ARKit

class AppData: NSObject {
    static var currData:String = ""
    static var CurrentViewController:UIViewController? = nil
    static var currPlayerType:PlayerType = .Player
    static var nodeDict:[Int: SCNNode] = [:]
}

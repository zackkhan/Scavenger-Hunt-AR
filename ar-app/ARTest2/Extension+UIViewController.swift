//
//  Extension+UIViewController.swift
//  ARTest2
//
//  Created by MetroStar on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

protocol Listener {
    func onGetData(message:String)
}
extension UIViewController: Listener {
    func onGetData(message: String) {
        
    }
    
    
}

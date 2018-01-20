//
//  AppDefs.swift
//  ARTest2
//
//  Created by Tamer Bader on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation

enum PlayerMessages: String {
    case GetCoordinate = "GetCoordinates"
    case InitialGameHash = "InitialGameHash"
    case DeleteIndex = "DeleteIndex"
    case Winner = "Winner"
}

enum HostMessages: String {
    case DeleteIndex = "DeleteIndex"
    
}

enum PlayerType: String {
    case Host = "Host"
    case Player = "Player"
}

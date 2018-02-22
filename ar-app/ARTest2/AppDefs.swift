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
    case HostIdentifier = "HostIdentifier"
    case StartGame = "StartGame"
}

enum HostMessages: String {
    case DeleteIndex = "DeleteIndex"
}

enum PlayerSendRequests: String {
    case IsReady = "IsReady"
    case IsHost = "IsHost"

}

enum PlayerType: String {
    case Host = "Host"
    case Player = "Player"
}

enum Model: Int {
    case Penguin  = 0
    case Sunglass = 1
    case Soccer = 2
    case Ball = 3
}

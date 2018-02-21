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
    case Sunglass = 0
    case Soccer = 1
    case Ball = 2
    case Penguin = 3
}

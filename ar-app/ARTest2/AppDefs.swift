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
}

enum HostMessages: String {
    case DeleteIndex = "DeleteIndex"
}

enum PlayerSendRequests: String {
    case IsReady = "IsReady"
}
enum HostSendRequests: String {
    case IsHost = "IsHost"
    case StartGame = "StartGame"
}

enum PlayerType: String {
    case Host = "Host"
    case Player = "Player"
}

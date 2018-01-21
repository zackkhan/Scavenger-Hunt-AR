//
//  Helpers.swift
//  ARTest2
//
//  Created by MetroStar on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import MultipeerConnectivity


func getRandomValue (lower:Float, upper:Float) -> Float{
    let arc4randoMax:Double = 0x100000000
    let ab = (Double(arc4random()) / arc4randoMax)
    return Float(ab) * (upper - lower) + lower
}

func getConnectedPlayers(allConnected: Array<MCPeerID>) -> Array<MCPeerID> {
    var connectedPlayers: Array<MCPeerID> = Array<MCPeerID>()
    for peerId in allConnected {
        if (peerId.displayName != AppData.hostPeerId) {
            connectedPlayers.append(peerId)
        }
    }
    return connectedPlayers
}

func getHost() -> Array<MCPeerID> {
    var host: Array<MCPeerID> = Array<MCPeerID>()
    host.append(MCPeerID(displayName: AppData.hostPeerId))
    
    return host
}

//
//  MPCServiceManager.swift
//  Peer2Peer
//
//  Created by Tamer Bader on 1/20/18.
//  Copyright © 2018 Kodactive. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import ARKit

protocol MPCServiceManagerDelegate {
    func connectedDeviceChanged(manager: MPCServiceManager, connectedDevices: [String])
    func valueChanged(manager: MPCServiceManager, message: String)
}

class MPCServiceManager: NSObject {
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let serviceType = "example-color"
    
    static var sharedInstance:MPCServiceManager = MPCServiceManager()
    
    // peerId is current device
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    
    // create the advartiser & browser variables
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    //create session property
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self as MCSessionDelegate
        return session
    }()
    
    var delegate : MPCServiceManagerDelegate?
    
    override init() {
        // initialize the advartiser And browser
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        
        // set the both delegates to self
        self.serviceAdvertiser.delegate = self as MCNearbyServiceAdvertiserDelegate
        self.serviceBrowser.delegate = self as MCNearbyServiceBrowserDelegate
        
        // start the functions
        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceBrowser.startBrowsingForPeers()
    }
   
    func send(message:Data) {
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(message, toPeers: session.connectedPeers, with: .reliable)
            } catch let error {
                print(error)
            }
        }
    }
    
    
    deinit {
        // deinitialize the object by stopping functions
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
}
extension MPCServiceManager : MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Did recieve an invitation from \(peerID)")
        
        invitationHandler(true, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error)
    }
}

extension MPCServiceManager : MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found Peer\(peerID)")
        
        print("invite the peer \(peerID)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost Peer \(peerID)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Did not start browsing for peers \(error)")
    }
}

extension MPCServiceManager : MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("the Peer \(peerID) changed the state \(state)")
        self.delegate?.connectedDeviceChanged(manager: self, connectedDevices: session.connectedPeers.map{$0.displayName})
        if (session.connectedPeers.count > 0) {
            
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("We did recieve the data \(data)")
        
        if (AppData.currPlayerType == .Player)
        {
            onPlayerReceivedData(session: session, didReceieve: data, fromPeer: peerID)
        }
        else
        {
            onHostReceivedData(session: session, didReceieve: data, fromPeer: peerID)
        }
        
    }
    
    func onPlayerReceivedData(session: MCSession, didReceieve data: Data, fromPeer peerID: MCPeerID) {
        let resultsHash: [String: Any]? = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String : Any]?
        if (resultsHash != nil && resultsHash?.keys.first != nil) {
            let messageType:PlayerMessages = PlayerMessages(rawValue: (resultsHash?.keys.first)!)!
            switch messageType {
            case .DeleteIndex:
                let value: Int = resultsHash![resultsHash!.keys.first!]! as! Int
                AppData.nodeDict[value]?.removeFromParentNode()
                
            case .GetCoordinate:
                print("Get Coordinate")
                
            case .InitialGameHash:
            //construct a hash
                let val: Array<[String: Any]> = resultsHash![resultsHash!.keys.first!]! as! Array<[String: Any]>
                for index in 0...val.count {
                let currDict = val[index]
                    (AppData.CurrentViewController as! ViewController?)?.addModel(x:currDict["x"] as! Float, y:currDict["y"] as! Float, z:currDict["z"] as! Float, modelNum:currDict["model"] as! Int, Index: index as! Int)
                }
            
            case .Winner:
                print("Winner")
            }
        }
    }
    
    func onHostReceivedData(session: MCSession, didReceieve data: Data, fromPeer peerID: MCPeerID) {
        let resultsHash: [String: Any]? = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String : Any]?
        if (resultsHash != nil && resultsHash?.keys.first != nil) {
            let messageType:HostMessages = HostMessages(rawValue: (resultsHash?.keys.first)!)!
            switch messageType {
            case .DeleteIndex :
                print("Delete Index")
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("did recieve stream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("didFinishReceivingResourceWithName")
    }
}


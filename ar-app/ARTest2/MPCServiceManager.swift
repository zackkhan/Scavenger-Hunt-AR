//
//  MPCServiceManager.swift
//  Peer2Peer
//
//  Created by Tamer Bader on 1/20/18.
//  Copyright © 2018 Kodactive. All rights reserved.
//

import UIKit
import MultipeerConnectivity

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
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("We did recieve the data \(data)")
        
        let resultsHash: [String: Any]? = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String : Any]?
        
        if (resultsHash != nil && resultsHash?.keys.first != nil) {
            var value = resultsHash![resultsHash!.keys.first!]!
            let messageType:PlayerMessages = PlayerMessages(rawValue: (resultsHash?.keys.first)!)!
            switch messageType {
            case .DeleteIndex:
                AppData.nodeDict[Int(value)].removeFromParentNode()
            case .GetCoordinate:
                print("Get Coordinate")
            case .InitialGameHash:
                AppData.nodeDict = value
                for key in AppData.nodeDict {
                    ViewController.addNode(AppData.nodeDict[key])
                }
            case .Winner:
                print("Winner")
            }
        }
        

        let str = String(data: data, encoding: .utf8)!
        self.delegate?.valueChanged(manager: self, message: str)
        AppData.currData = str
        AppData.CurrentViewController?.onGetData(message: str)
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


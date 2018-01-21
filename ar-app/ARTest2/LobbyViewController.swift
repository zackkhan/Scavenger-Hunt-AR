//
//  LobbyViewController.swift
//  ARTest2
//
//  Created by Tamer on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class LobbyViewController: UIViewController {

    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var btnStartGame: UIButton!
    
    private var managerInstance: MPCServiceManager = MPCServiceManager.sharedInstance
    private var readyPlayers: Array<String> = Array<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()

    }
    
    private func initialize() {
        if (AppData.currPlayerType == .Player) {
            btnStartGame.isHidden = true
            readyButton.isHidden = false
        } else {
            btnStartGame.isHidden = false
            readyButton.isHidden = true
            
            var isHostMessage: [String: String] = [:]
            isHostMessage[HostSendRequests.IsHost.rawValue] = UIDevice.current.name
            
            var data:Data = NSKeyedArchiver.archivedData(withRootObject: isHostMessage)
            MPCServiceManager.sharedInstance.sendToPlayers(message: data)
        }
        
        
    }

    @IBAction func onStartGame(_ sender: UIButton) {
        
        
    }
    
    @IBAction func onReady(_ sender: UIButton) {
        var message: [String: String] = [:]
        message[PlayerSendRequests.IsReady.rawValue] = UIDevice.current.name
        
        let data:Data = NSKeyedArchiver.archivedData(withRootObject: message)
        MPCServiceManager.sharedInstance.sendToHost(message: data)
    }
    

}

extension LobbyViewController: MPCServiceManagerDelegate {
    func connectedDeviceChanged(manager: MPCServiceManager, connectedDevices: [String]) {
        print("Connected Device Changed in Lobby")
    }
    
    func valueChanged(manager: MPCServiceManager, message: String) {
        print("Value has changed in Lobby \(message)")
    }
    
    func playerGotReady(manager: MPCServiceManager, player: String) {
        self.readyPlayers.append(player)
        if (readyPlayers.count == MPCServiceManager.sharedInstance.session.connectedPeers.count) {
            print("We have started Game")
            
            var startGameMessage: [String: Bool] = [:]
            startGameMessage[HostSendRequests.StartGame.rawValue] = true
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: startGameMessage)
            MPCServiceManager.sharedInstance.sendToPlayers(message: data)
            self.performSegue(withIdentifier: "startGame", sender: nil)

        }
    }
    
    
}

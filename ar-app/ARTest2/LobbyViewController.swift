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

    @IBAction func mapAction(_ sender: Any) {
        Socket.sharedInstance.emit
    }
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var btnStartGame: UIButton!
    
    private var managerInstance: MPCServiceManager = MPCServiceManager.sharedInstance
    private var readyPlayers: Array<String> = Array<String>()
    
    @IBAction func readyClick(_ sender: Any) {
        if AppData.currPlayerType == PlayerType.Host {
            AppData.propsDict = createPropsDict()
            sendPropsDict()
        } else {
            var message: [String: String] = [:]
            message[PlayerSendRequests.IsReady.rawValue] = UIDevice.current.name
            let data:Data = NSKeyedArchiver.archivedData(withRootObject: message)
            MPCServiceManager.sharedInstance.sendToHost(message: data)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()

    }
    
    private func initialize() {
        AppData.CurrentViewController = self
        if (AppData.currPlayerType == .Player) {
            btnStartGame.isHidden = true
            readyButton.isHidden = false
        } else {
            btnStartGame.isHidden = false
            readyButton.isHidden = true
            
            var isHostMessage: [String: String] = [:]
            isHostMessage[PlayerMessages.HostIdentifier.rawValue] = UIDevice.current.name
            
            var data:Data = NSKeyedArchiver.archivedData(withRootObject: isHostMessage)
            MPCServiceManager.sharedInstance.sendToPlayers(message: data)
        }
    }

    @IBAction func onStartGame(_ sender: UIButton) {
        if (readyPlayers.count == MPCServiceManager.sharedInstance.session.connectedPeers.count) {
            print("We have started Game")
            
            var startGameMessage: [String: Bool] = [:]
            startGameMessage[PlayerMessages.StartGame.rawValue] = true
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: startGameMessage)
            MPCServiceManager.sharedInstance.sendToPlayers(message: data)
            self.performSegue(withIdentifier: "startGame", sender: nil)
        }
        
    }
    
    @IBAction func onReady(_ sender: UIButton) {
        var message: [String: String] = [:]
        message[PlayerSendRequests.IsReady.rawValue] = UIDevice.current.name
        
        let data:Data = NSKeyedArchiver.archivedData(withRootObject: message)
        MPCServiceManager.sharedInstance.sendToHost(message: data)
    }
    func createPropsDict() -> Array<[String: Any]> {
        var propsDict: Array<[String: Any]> = []
        for i in 0...100 {
            var props: [String: Any] = [:]
            props["model"] = Int(arc4random_uniform(4))
            props["x"] = getRandomValue(lower: -2.0, upper: 2.0)
            props["y"] = getRandomValue(lower: -2.0, upper: 2.0)
            props["z"] = getRandomValue(lower: -1.0, upper: 2.0)
            propsDict.append(props)
        }
        return propsDict
    }
    
    func sendPropsDict() {
        for prop in AppData.propsDict {
            let data = NSKeyedArchiver.archivedData(withRootObject: prop)
            MPCServiceManager.sharedInstance.sendToPlayers(message: data)
        }
    }
    

}

extension LobbyViewController: MPCServiceManagerDelegate {
    func startedGame(manager: MPCServiceManager) {
        self.performSegue(withIdentifier: "startGame", sender: nil)
    }
    
    func connectedDeviceChanged(manager: MPCServiceManager, connectedDevices: [String]) {
        print("Connected Device Changed in Lobby")
    }
    
    func valueChanged(manager: MPCServiceManager, message: String) {
        print("Value has changed in Lobby \(message)")
    }
    
    func playerGotReady(manager: MPCServiceManager, player: String) {
        self.readyPlayers.append(player)
        self.countLabel.text = "\(readyPlayers.count) Players Are Ready"
    }
    
    
}

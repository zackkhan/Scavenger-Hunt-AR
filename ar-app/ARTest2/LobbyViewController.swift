//
//  LobbyViewController.swift
//  ARTest2
//
//  Created by Tamer on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import SwiftSpinner

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
        AppData.CurrentViewController = self
        if (AppData.currPlayerType == .Player) {
            btnStartGame.isHidden = true
            readyButton.isHidden = false
        } else {
            btnStartGame.isHidden = false
            readyButton.isHidden = true
        }
        Socket.sharedInstance.generateGameMap()
    }

    
    @IBAction func readyClick(_ sender: Any) {
        Socket.sharedInstance.sendReadyEmit()
        Socket.sharedInstance.getGameMap()
    }
    

    @IBAction func onStartGame(_ sender: UIButton) {
        Socket.sharedInstance.generateGameMap()
        Socket.sharedInstance.getGameMap()
    }
    
    /*
 var startGameMessage: [String: Bool] = [:]
 startGameMessage[PlayerMessages.StartGame.rawValue] = true
 if (AppData.currPlayerType == .Player) {
 SwiftSpinner.show("Waiting for Host to Hide Object...")
 }
 
 */
 

}

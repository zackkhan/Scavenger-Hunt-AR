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

    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var btnStart: UIButton!
    
    @IBOutlet weak var btnView: UIView!
    private var readyPlayers: Array<String> = Array<String>()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()

    }
    
    private func initialize() {
        AppData.CurrentViewController = self
        btnView.layer.cornerRadius = btnView.frame.width * 0.05
        if (AppData.currPlayerType == .Player) {
            btnStart.setTitle("Ready To Play?", for: .normal)
        } else {
           btnStart.setTitle("Start Game", for: .normal)
        }
        
        Socket.sharedInstance.generateGameMap()
    }

    @IBOutlet weak var btnOnStart: UIButton!
    
    @IBAction func btnOnStart(_ sender: UIButton) {
        if (AppData.currPlayerType == .Host) {
            Socket.sharedInstance.generateGameMap()
            Socket.sharedInstance.getGameMap()
        } else {
            Socket.sharedInstance.sendReadyEmit()
            Socket.sharedInstance.getGameMap()
        }
    }
    
    /*
 var startGameMessage: [String: Bool] = [:]
 startGameMessage[PlayerMessages.StartGame.rawValue] = true
 if (AppData.currPlayerType == .Player) {
 SwiftSpinner.show("Waiting for Host to Hide Object...")
 }
 
 */
 

}

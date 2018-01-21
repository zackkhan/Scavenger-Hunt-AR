//
//  MainPageController.swift
//  ARTest2
//
//  Created by MetroStar on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class MainPageController: UIViewController {

    @IBOutlet weak var btnCreateGame: UIButton!
    
    @IBOutlet weak var btnJoinGame: UIButton!
    
    @IBOutlet weak var top_logo_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottom_logo_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottom_create_btn_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var right_create_btn_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var left_create_btn_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var left_join_btn_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var right_join_btn_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottom_join_button_constraint: NSLayoutConstraint!
    
    @IBAction func onCreateGame(_ sender: UIButton) {
        AppData.currPlayerType = .Host
        self.performSegue(withIdentifier: "moveToLobby", sender: nil)
    }
    
    @IBAction func onJoinGame(_ sender: UIButton) {
        AppData.currPlayerType = .Player
        self.performSegue(withIdentifier: "moveToLobby", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        AppData.CurrentViewController = self
        top_logo_constraint.constant = self.view.frame.height * 0.2
        bottom_logo_constraint.constant = self.view.frame.height * 0.3
        bottom_create_btn_constraint.constant = self.view.frame.height * -0.18
        left_create_btn_constraint.constant = self.view.frame.width * 0.2
        right_create_btn_constraint.constant = self.view.frame.width * -0.2
        bottom_join_button_constraint.constant = self.view.frame.height * 0.05
        left_join_btn_constraint.constant = self.view.frame.width * 0.3
        right_join_btn_constraint.constant = self.view.frame.width * -0.3
    }
}

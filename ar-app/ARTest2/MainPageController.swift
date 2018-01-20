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
    
    @IBAction func onCreateGame(_ sender: UIButton) {
        AppData.currPlayerType = .Host
        self.performSegue(withIdentifier: "moveToGame", sender: nil)
    }
    
    @IBAction func onJoinGame(_ sender: UIButton) {
        AppData.currPlayerType = .Player
        self.performSegue(withIdentifier: "moveToGame", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ResultViewController.swift
//  ARTest2
//
//  Created by MetroStar on 1/21/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var yourResultLabel: UILabel!
    @IBOutlet var superView: UIView!
    
    var didWin:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (AppData.currPlayerType == .Player) {
            if (AppData.didWin) {
                yourResultLabel.text = "YOU WON!"
                superView.backgroundColor = UIColor(displayP3Red: 230/255, green: 99/255, blue: 102/255, alpha: 1)
            } else {
                yourResultLabel.text = "YOU LOST!"
                superView.backgroundColor = UIColor.black
            }
        } else {
            yourResultLabel.text = "GAME OVER"
            superView.backgroundColor = UIColor(displayP3Red: 230/255, green: 99/255, blue: 102/255, alpha: 1)
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPlayAgain(_ sender: Any) {
        self.performSegue(withIdentifier: "playAgain", sender: nil)
        resetEverything()
        
    }
    @IBAction func onBackHome(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backHome", sender: nil)
        resetEverything()
    }
    
    private func resetEverything() {
        AppData.currData = ""
        AppData.CurrentViewController = nil
        //AppData.currPlayerType = .Player
        AppData.nodeDict = [:]
        AppData.hostPeerId = ""
        AppData.propsDict = Array<[String: Any]>()
        AppData.goalObjectDict = [:]
        AppData.hostObjectNode = nil
        AppData.didWin = false
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

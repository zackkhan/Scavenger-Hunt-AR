//
//  LobbyViewController.swift
//  ARTest2
//
//  Created by Tamer on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {

    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBAction func readyClick(_ sender: Any) {
        if AppData.currPlayerType == PlayerType.Host {
            AppData.propsDict = createPropsDict()
        }
        self.performSegue(withIdentifier: "moveToGame", sender: nil)
    }
    
    func getRandomValue (lower:Float, upper:Float) -> Float{
        let arc4randoMax:Double = 0x100000000
        let ab = (Double(arc4random()) / arc4randoMax)
        return Float(ab) * (upper - lower) + lower
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
}

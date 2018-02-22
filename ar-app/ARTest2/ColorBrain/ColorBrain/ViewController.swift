//
//  ViewController.swift
//  ColorBrain
//
//  Created by MetroStar on 2/2/18.
//  Copyright © 2018 Tamer Bader. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var helloGlowLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let glowColor:UIColor = UIColor(displayP3Red: 107/255, green: 106/255, blue: 251/255, alpha: 1)
        //let glowColor:CGColor = UIColor.red.cgColor
        helloGlowLabel.layer.shadowColor = glowColor.cgColor
        helloGlowLabel.layer.shadowRadius = 3.0
        helloGlowLabel.layer.shadowOpacity = 0.8
        helloGlowLabel.shadowOffset = CGSize.zero
        helloGlowLabel.layer.masksToBounds = false
        
        /*
        UIColor *color = button.currentTitleColor;
        button.titleLabel.layer.shadowColor = [color CGColor];
        button.titleLabel.layer.shadowRadius = 4.0f;
        button.titleLabel.layer.shadowOpacity = .9;
        button.titleLabel.layer.shadowOffset = CGSizeZero;
        button.titleLabel.layer.masksToBounds = NO;*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


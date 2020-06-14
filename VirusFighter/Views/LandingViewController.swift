//
//  LandingViewController.swift
//  VirusFighter
//
//  Created by Fran González on 14/06/2020.
//  Copyright © 2020 Fran González Ramos. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        highScoreLabel.text = "High Score: \(UserDefaults.standard.integer(forKey: "HighScore"))"
    }
}

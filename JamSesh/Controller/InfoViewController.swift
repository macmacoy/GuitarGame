//
//  InfoViewController.swift
//  JamSesh
//
//  Created by Mac Macoy on 3/23/19.
//  Copyright © 2019 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var metronomeToggle: UISwitch!
    
    @IBAction func metronomeToggleChanged(_ sender: UISwitch) {
        SongPlayer.metronomeOn = sender.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show back button
        self.navigationController?.isNavigationBarHidden = false
        
        // set background
        setBackground()
        
        // set metronome toggle
        metronomeToggle.isOn = SongPlayer.metronomeOn
    }
    
    func setBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.2705882353, green: 0.5882352941, blue: 0.6784313725, alpha: 1).cgColor, #colorLiteral(red: 0.3529411765, green: 0.7529411765, blue: 0.7176470588, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

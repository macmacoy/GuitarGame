//
//  MainMenuViewController.swift
//  JamSesh
//
//  Created by Mac Macoy on 11/29/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import UIKit

class MainMenuViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !Player.registered {
            let signUpViewController = Utils.getViewController(viewControllerName: "SignUpViewController")
            Utils.setCurrentViewController(from: self, to: signUpViewController)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

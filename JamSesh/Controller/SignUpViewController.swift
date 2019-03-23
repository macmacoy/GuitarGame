//
//  SignUpViewController.swift
//  JamSesh
//
//  Created by Mac Macoy on 1/5/19.
//  Copyright © 2019 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var banner: UILabel!
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        setBackground()
        
        // make button rounded
        playButton.layer.cornerRadius = 10; // this value vary as per your desire
        playButton.clipsToBounds = true;
        
        // so hitting return will go to next text field
        firstNameText.delegate = self
        firstNameText.tag = 0
        emailText.delegate = self
        emailText.tag = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        Player.createPlayer(firstName: firstNameText.text!, email: emailText.text!)
        callCreatePlayerApi(email: emailText.text!, firstName: firstNameText.text!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.2705882353, green: 0.5882352941, blue: 0.6784313725, alpha: 1).cgColor, #colorLiteral(red: 0.3529411765, green: 0.7529411765, blue: 0.7176470588, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func callCreatePlayerApi(email: String, firstName: String) {
        let scheme = "https"
        let host = "qx31b8ilpf.execute-api.us-east-1.amazonaws.com"
        let path = "/beta/create-user"
        let queryItemEmail = URLQueryItem(name: "email", value: email)
        let queryItemFirstName = URLQueryItem(name: "firstName", value: firstName)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItemEmail, queryItemFirstName]
        
        let url = urlComponents.url
        
        let response = WebApi.post(url: url!, host: host)
        if let _ = response?["status"] {
            if response?["status"] as? String != "success" {
                print("error calling create player api")
            }
        }
        else {
            print("error calling create player api")
        }
    }
    
    // UITextFieldDelegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
}

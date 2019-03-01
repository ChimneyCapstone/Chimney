//
//  SignInViewController.swift
//  chimney
//
//  Created by Kangwoo on 2/17/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    
    // Reference: https://www.youtube.com/watch?v=asKXHVUZiIY
    // https://www.youtube.com/watch?v=UPKCULKi0-A
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        // TODO: Validate email and password
        
        if let email = emailTextField.text, let pass = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                
                // Check that user is not nil
                if let u = user {
                    
                    // User is found, go to home screen for now
                    // TODO: Where to go next?
                    
                    // Need to use `self` at the beginning because this is in a closure
                    self.performSegue(withIdentifier: "signInToHome", sender: self)
                    
                } else {
                    
                    // Error: check error and show message
                    
                }
                
            }
            
        }
        
    }
    
    
}


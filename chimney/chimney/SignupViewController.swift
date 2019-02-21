//
//  SignupViewController.swift
//  chimney
//
//  Created by Kangwoo on 2/16/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GooglePlaces

class SignupViewController: UIViewController {

    var placesClient: GMSPlacesClient!
    // Fields for email and password
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordMatchingTextField: UITextField!
    // Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        placesClient = GMSPlacesClient.shared()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    // signupButton is for activating create user in out server.
    // Reference: https://www.youtube.com/watch?v=jKV9rV2JDVE
    // https://stackoverflow.com/questions/27210087/how-to-add-and-check-for-a-confirm-password-to-sign-up-via-parse
    @IBAction func signUpButton(_ sender: UIButton){
        var a = false
        var b = false
        if passwordTextField.text! == passwordMatchingTextField.text! {
            a = true
        } else {
            
        }
        
        if passwordTextField.text! == "" || passwordMatchingTextField.text! == "" {
            
        } else {
            
            b = true
        }
        
        if a == true && b == true {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if user != nil {
                    print("User created!")
                    self.performSegue(withIdentifier: "GotoLogin", sender: self)
                } else {
                    print("Error: error occurs when creating a user")
                }
            }
        }
        
    }

}

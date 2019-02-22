//
//  SignUpViewController.swift
//  chimney
//
//  Created by Kangwoo on 2/16/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleMaps
import GooglePlaces

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    var arrayAddress = [GMSAutocompletePrediction]()
    lazy var filter: GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        return filter
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
    }
  
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        // TODO: Validate email and password
        
        if let name = fullNameTextField.text, let email = emailTextField.text, let phone = phoneTextField.text, let pass = passwordTextField.text, let cpass = confirmPasswordTextField.text, let street = streetAddressTextField.text, let city = cityTextField.text, let state = stateTextField.text, let zip = zipTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                
                // Check that user is not nil
                if let u = user {
                    
                    // User is found, go to home screen for now
                    // TODO: Where to go next?
                    
                    // Need to use `self` at the beginning because this is in a closure
                    self.performSegue(withIdentifier: "signUpToHome", sender: self)
                    
                } else {
                    
                    // Error: check error and show message
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    
    }
    
}

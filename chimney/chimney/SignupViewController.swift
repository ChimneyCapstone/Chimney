//
//  SignupViewController.swift
//  chimney
//
//  Created by Kangwoo on 2/16/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import UIKit
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
    @IBAction func signUpButton(_ sender: UIButton){
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
                print("User created!")
                self.performSegue(withIdentifier: "GotoLogin", sender: self)
            } else {
                print("Error: error occurs when creating a user")
            }
        }
    }
    
    // Add a UIButton in Interface Builder, and connect the action to this function.
    // Reference: https://developers.google.com/places/ios-sdk/start
    @IBAction func getCurrentPlace(_ sender: UIButton) {
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                }
            }
        })
    }

}

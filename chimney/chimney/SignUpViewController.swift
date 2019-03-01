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
// import GooglePlaces // for address autocompleting options

// This class is the view controller of sign-up page
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
//    variables for autocompleting
//    place API 
//    var arrayAddress = [GMSAutocompletePrediction]()
//    lazy var filter: GMSAutocompleteFilter = {
//        let filter = GMSAutocompleteFilter()
//        filter.type = .address
//        return filter
//    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
    }
    // Check whether email address is vaild
    // Reference: https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift/52282751
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    // check the field whether it fulfilled or not
    func checkFulfilled () -> Bool {
        guard fullNameTextField.text != nil else {
            let alertController = UIAlertController(title: "Miss full name field", message: "you should type the full name", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        guard emailTextField.text != nil else {
            let alertController = UIAlertController(title: "Miss email field", message: "you should type the email", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        guard isValidEmail(testStr: emailTextField.text!) else {
            let alertController = UIAlertController(title: "Need to type valid Email", message: "you should type the proper email", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        guard passwordTextField.text != nil || confirmPasswordTextField.text == nil else {
            let alertController = UIAlertController(title: "", message: "you should type the name", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        // check password is matching wirh password confirmation
        guard passwordTextField.text != confirmPasswordTextField.text else {
            let alertController = UIAlertController(title: "Miss password field", message: "you should type the password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        // city
        guard cityTextField.text != nil else {
            let alertController = UIAlertController(title: "Miss city textfield", message: "you should type the password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        // state
        guard stateTextField.text == nil else {
            let alertController = UIAlertController(title: "Miss state field", message: "you should type the state", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        guard zipTextField.text == nil else {
            let alertController = UIAlertController(title: "Miss zip field", message: "you should type the zipcode", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    // after tapping sign up button
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        // if there is an empty space on each field, return the alert.
        if (checkFulfilled()) {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            // Check that user is not nil
                if let u = user {
                    // User is found, go to home screen for now
                    // TODO: Where to go next?
                    // Need to use `self` at the beginning because this is in a closure
                    
                    self.performSegue(withIdentifier: "signUpToHome", sender: self)
                } else {
                    // Error: check error and show message
                    let alertController = UIAlertController(title: "Error occurs", message: error!.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
}

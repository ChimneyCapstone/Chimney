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
import Firebase
// import GooglePlaces // for address autocompleting options

// This class is the view controller of sign-up page
class SignUpViewController: UIViewController {
    
    // Buttons and text fields
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
    
    // database reference
    var ref: DatabaseReference!
    
    

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
        // initialize the reference 
        ref = Database.database().reference()
    }
    // Check whether email address is vaild
    // Reference: https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift/52282751
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    // after tapping sign up button
    // reference: https://stackoverflow.com/questions/51388655/firebase-email-verification-swift
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        // if there is an empty space on each field, return the alert.
        let errorString = "Error"
        if fullNameTextField.text == nil  {
            let alertController = UIAlertController(title: errorString, message: "you should type the full name", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if emailTextField.text == nil {
            let alertController = UIAlertController(title: errorString, message: "you should type the email", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if passwordTextField.text == nil || confirmPasswordTextField.text == nil {
            let alertController = UIAlertController(title: errorString, message: "you should type the password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if passwordTextField.text != confirmPasswordTextField.text {
            let alertController = UIAlertController(title: errorString, message: "you should confirm password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if cityTextField.text == nil {
            let alertController = UIAlertController(title: errorString, message: "you should type the city", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if stateTextField.text == nil {
            let alertController = UIAlertController(title: errorString, message: "you should type the state", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if zipTextField.text == nil {
            let alertController = UIAlertController(title: errorString, message: "you should type the zipcode", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil && user != nil {
                    let userData = ["full name": self.fullNameTextField.text! as String,
                                    "city": self.cityTextField.text! as String,
                                    "zipcode":self.zipTextField.text! as String,
                                    "state":self.stateTextField.text! as String]
                    
                    self.ref.child("users").child(user!.user.uid).setValue(userData)
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                } else {
                    let alertController = UIAlertController(title: errorString, message: error!.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

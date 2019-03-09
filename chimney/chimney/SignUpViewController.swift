//
//  SignUpViewController.swift
//  chimney
//
//  Created by Kangwoo on 3/2/19.
//  Copyright © 2019 chimney. All rights reserved.
//
// need to add phone number


import Foundation
import UIKit
import FirebaseAuth // for authenication
import Firebase

class SignUpViewController: UIViewController{
    // text fields
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    // database reference
    var ref: DatabaseReference!
    var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize the reference
        ref = Database.database().reference()
    }
   
    @IBAction func phoneTextEdit(_ sender: Any) {
        
    }
    
    // after tapping sign up button
    // reference: https://stackoverflow.com/questions/53628375/how-to-store-user-data-in-ios-firebase-with-swift-4
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        // if there is an empty space on each field, return the alert.
//        print(fullNameTextField.text)
        let errorString = "Error"
        if fullNameTextField.text == ""  {
//            print("Debug1")
            let alertController = UIAlertController(title: errorString, message: "you should type the full name", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            
        } else if self.emailTextField.text == "" {
//            print("Debug2")
            let alertController = UIAlertController(title: errorString, message: "you should type the email", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if self.passwordTextField.text == nil || confirmPasswordTextField.text == nil {
//            print("Debug3")
            let alertController = UIAlertController(title: errorString, message: "you should type the password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if self.passwordTextField.text != self.confirmPasswordTextField.text {
//            print("Debug4")
            let alertController = UIAlertController(title: errorString, message: "you should confirm password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if self.phoneTextField == nil {
            let alertController = UIAlertController(title: errorString, message: "you type phone number", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if isValidMobile(testStr: self.phoneTextField.text!) {
            let alertController = UIAlertController(title: errorString, message: "Type valid phone number", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else {
            // create user on Firebase
//            print("Debug5")
            Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
                    let userData = ["phone": self.phoneTextField.text,
                                    "fullname": self.fullNameTextField.text]
                    self.ref.child("users").child(user!.user.uid).setValue(userData)
                    self.performSegue(withIdentifier: "nextStep", sender: self)
                } else {
                    print("Debug " + error!.localizedDescription)
                    let alertController = UIAlertController(title: errorString, message: error!.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // check if it's valid phone number
    // https://stackoverflow.com/questions/53427424/how-to-validate-american-phone-format-in-swift-4
    func isValidMobile(testStr:String) -> Bool {
        let mobileRegEx = "^[1{1}]\\s\\d{3}-\\d{3}-\\d{4}$"
        let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
        return mobileTest.evaluate(with: testStr)
    }
    
//     sending data to next view controller
//     reference: https://www.youtube.com/watch?v=uKQjJb-KSwU
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "nextStep") {
            var vc = segue.destination as! AddAddressViewController
            vc.fullName = self.fullNameTextField.text!
        }
    }
    
}

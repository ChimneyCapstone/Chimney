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

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // sign in
    // Reference: https://www.youtube.com/watch?v=asKXHVUZiIY
    // https://www.youtube.com/watch?v=UPKCULKi0-A
    // https://medium.com/@ashikabala01/how-to-build-login-and-sign-up-functionality-for-your-ios-app-using-firebase-within-15-mins-df4731faf2f7
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        // TODO: Validate email and password
        if let email = emailTextField.text, let pass = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "signInToHome", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}


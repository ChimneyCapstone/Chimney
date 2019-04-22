//
//  ChangePasswordViewController.swift
//  chimney
//
//  Created by Kangwoo on 4/16/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    
    var ref: DatabaseReference!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // handle a save button
    @objc func saveButtonTapped() {
        if (passwordTextField.text == retypePasswordTextField.text) {
            Auth.auth().sendPasswordReset(withEmail: Auth.auth().currentUser!.email!) { (error) in {
                    if (error != nil) {
                        let alertController = UIAlertController(title:"Error", message: "Error in server!", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(action)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        let vc = ProfileViewController()
                        self.present(vc, animated: true, completion: nil)
                    }
                }()
            }
        } else {
            let alertController = UIAlertController(title:"Error", message: "passwords do not match!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // handle a sign out button
    @objc func handleSignOutButtonTapped() {
        let alertController = UIAlertController(title: "Sign Out", message: "Are you sure that you sign out?", preferredStyle: .alert)
        let signout = UIAlertAction(title: "Sign Out", style: .default) { (action:UIAlertAction) in
            do {
                try Auth.auth().signOut()
            } catch let err {
                let errorAlertController = UIAlertController(title:"Error", message: err.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                errorAlertController.addAction(action)
                self.present(errorAlertController, animated: true, completion: nil)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        
        alertController.addAction(signout)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

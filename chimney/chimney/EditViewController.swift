//
//  EditViewController.swift
//  chimney
//
//  Created by Kangwoo on 4/16/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import UIKit
import Firebase

class EditViewController: UIViewController {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    
    var ref: DatabaseReference!
    var uid: String?
    
    override func viewDidLoad() {
        self.title = "Edit Profile"
        ref = Database.database().reference()
        self.uid = Auth.auth().currentUser!.uid
        
    }
    
    @objc func saveButtonTapped() {
//        let updateValueAddress
//        self.ref.child("user").child(self.uid).child("address").updateChildValues(updateValue)
    }
    
    @objc func resetPasswordButtonTapped() {
        let changeViewController = ChangePasswordViewController()
        self.present(changeViewController, animated: true, completion: nil)
    }
    
    @objc func cancelButtonTapped() {
        let profileViewController = ProfileViewController()
        self.present(profileViewController, animated: true, completion: nil)
    }
    
    // handle sign out button
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

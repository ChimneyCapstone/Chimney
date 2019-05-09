//
//  ProfileViewController.swift
//  chimney
//
//  Created by Kangwoo on 4/4/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import UIKit
import Firebase
import Photos

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        self.title = "Profile"
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref.child("user").child(user!.uid).observeSingleEvent(of: .value, with: { snapshot in
            if let getData = snapshot.value as? [String: Any] {
                let name = getData["fullname"] as! String
                self.nameTextField.text = name
            }
        })
    }
    
    @IBAction func handleEditProfileButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "segToEdit", sender: <#T##Any?#>)
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
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) in
            print("You've pressed cancel");
        }
        
        alertController.addAction(signout)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
}

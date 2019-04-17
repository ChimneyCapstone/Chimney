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
}

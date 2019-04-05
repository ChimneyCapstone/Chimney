//
//  ProfileViewController.swift
//  chimney
//
//  Created by Kangwoo on 4/4/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController {
//
//
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        self.title = "Profile"
        ref = Database.database().reference()
    }
    
    
    
    
    
}

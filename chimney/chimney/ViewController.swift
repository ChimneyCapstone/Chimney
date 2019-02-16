//
//  ViewController.swift
//  chimney
//
//  Created by Kangwoo on 1/29/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    // loginTapped is for importing firebaseUI related to login
    // Reference: https://www.youtube.com/watch?v=brpt9Thi6GU
    @IBAction func loginTapped(_ sender: Any) {
        // Get the default auth UI object
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            // Log the Error
            print("Error: return nil when getting UI from FirebaseUI")
            return
        }
        // Set ourselves as the delegate
        authUI?.delegate = self
        
        // Get a reference to the auth UI view controller
        let authViewController = authUI!.authViewController()
        // Show it
        present(authViewController, animated: true, completion: nil)
    }
}

extension ViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        // check there is an error
        guard error != nil else {
            // Log the error
            print("Error: return error when delegating at the Viewcontroller")
            return
        }
        
        //        authDataResult?.user.uid
        performSegue(withIdentifier: "goHome", sender: self)
    }
}

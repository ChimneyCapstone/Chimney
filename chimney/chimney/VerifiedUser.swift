//
//  VerifiedUser.swift
//  chimney
//
//  Created by Kangwoo on 3/30/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension UIViewController {
    // verified a user
    func verifiedUser(user: User) -> User? {
        // check whether user signed in or not
        
        if Auth.auth().currentUser != nil {
            // User is signed in.
            return user
        } else {
            // No user is signed in.
            // ...
            let alertController = UIAlertController(title: "Error", message: "Need to Sign in first to access the page", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel) { (_) -> Void in
                self.performSegue(withIdentifier: "ErrorWithoutLogin", sender: self)
            }
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        return nil
    }
}

//
//  RequestViewController.swift
//  chimney
//
//  Created by Ziyi Zhuang on 3/2/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMaps


// This class is the view controller of sign-up page
class RequestViewController: UIViewController {
 
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var RequestTextField: UITextField!

    @IBOutlet weak var MoneyTextField: UITextField!

    
    // check the field whether it fulfilled or not
    func checkFulfilled () -> Bool {
        if Double(MoneyTextField.text!) == nil {
            let alertController = UIAlertController(title: "Bad currency format", message: "please check format of currency", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    

    // after tapping request button
   @IBAction func RequestButtonTapped(_ sender: UIButton) {

        // if there is an empty space on each field, return the alert.
        if (checkFulfilled()) {
            var ref: DatabaseReference!
            ref = Database.database().reference().child("users").child("1XrCfEdrhFageQnLnshRLXiPXaO2").child("request");
            ref.childByAutoId().setValue(RequestTextField.text)
        } else {
            // Error: check error and show message
            let alertController = UIAlertController(title: "Error occurs", message: "something went wrong"/*error!.localizedDescription*/, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
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
class RequestViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var RequestTextField: UITextView!
    
    @IBOutlet weak var MoneyTextField: UITextField!
    var buttonscheck = [UIButton]()
    @IBOutlet weak var free: UIButton!
    @IBOutlet weak var cash: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SubmitButton.isEnabled = false;
        self.title = "Request"
        RequestTextField.delegate = self
        RequestTextField.text = "What do you need? Please be as specific as possible."
        MoneyTextField.text = ""
        RequestTextField.textColor = UIColor.lightGray
        buttonscheck.append(free)
        buttonscheck.append(cash)
        MoneyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)


    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField.text == "" {
            SubmitButton.isEnabled = false;
        } else {
            SubmitButton.isEnabled = true
        }
    }
    
    @IBAction func btn_box(sender: UIButton)
    {
        for btn in buttonscheck {
            btn.isSelected = false
        }
        if let index = buttonscheck.index(where: { $0 == sender }) {
            buttonscheck[index].isSelected = true
        }
        if free.isSelected {
            SubmitButton.isEnabled = true;
        } else {
            SubmitButton.isEnabled = false;
        }
        if cash.isSelected {
            if Double(MoneyTextField.text!) == nil {
                SubmitButton.isEnabled = false;
            }else {
                SubmitButton.isEnabled = true;
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if RequestTextField.textColor == UIColor.lightGray {
            RequestTextField.text = ""
            RequestTextField.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if RequestTextField.text == "" {
            
            RequestTextField.text = "What do you need? Please be as specific as possible."
            RequestTextField.textColor = UIColor.lightGray
        }
    }
    
    // check the field whether it fulfilled or not
    func checkFulfilled () -> Bool {
        if free.isSelected {
            SubmitButton.isEnabled = true;
        } else {
            SubmitButton.isEnabled = false;
        }
        if cash.isSelected {
            if Double(MoneyTextField.text!) == nil {
                let alertController = UIAlertController(title: "Bad currency format", message: "please check format of currency", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return false
            }
            SubmitButton.isEnabled = true;
        }
        return true
    }
    
    
    // after tapping request button
    @IBAction func RequestButtonTapped(_ sender: UIButton) {
        
        // if there is an empty space on each field, return the alert.
        if (checkFulfilled()) {
            var ref: DatabaseReference!
            let uid = Auth.auth().currentUser!.uid
            ref = Database.database().reference().child("users").child(uid).child("request");
            ref.childByAutoId().setValue(["task": RequestTextField.text, "amount": MoneyTextField.text])
            let alertController = UIAlertController(title: "Successfully Requested!", message: "Your request has been posted!"/*error!.localizedDescription*/, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Great!", style: .default))
            self.present(alertController, animated: true, completion: nil)
            viewDidLoad()
        } else {
            // Error: check error and show message
            let alertController = UIAlertController(title: "Error occurs", message: "something went wrong"/*error!.localizedDescription*/, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func ProfileButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "profile", sender: self)
    }
}


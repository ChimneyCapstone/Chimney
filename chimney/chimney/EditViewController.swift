//
//  EditViewController.swift
//  chimney
//
//  Created by Kangwoo on 4/16/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import UIKit
import Firebase

class EditViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    
    var ref: DatabaseReference!
    var uid: String?
    var myPhoneNumber = String()
    
    override func viewDidLoad() {
        self.title = "Edit Profile"
        ref = Database.database().reference()
        self.uid = Auth.auth().currentUser!.uid
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        // for phone text field
        phoneTextField.delegate = self
        phoneTextField.keyboardType = .phonePad

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.phoneTextField) && textField.text == "" {
            textField.text = "+1 (" //your country code default
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            let res = phoneMask(phoneTextField: phoneTextField, textField: textField, range, string)
            myPhoneNumber = res.phoneNumber != "" ? "+\(res.phoneNumber)" : ""
            print("Phone - \(myPhoneNumber)  MaskPhone=\(res.maskPhoneNumber)")
            if (res.phoneNumber.count == 11) || (res.phoneNumber.count == 0) {
                //phone number entered or completely cleared
                print("EDIT END: Phone = \(myPhoneNumber)  MaskPhone = \(res.maskPhoneNumber)")
            }
            return res.result
        }
        return true
    }
    
    @IBAction func saveButtonTapped() {
        if (emailTextField.text == "" || fullNameTextField.text == "" || phoneTextField.text == "") {
            let alertController = UIAlertController(title: "Fields are empty", message: "You Should fill out at least one of the fields", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed cancel");
            }
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
        } else {
            if (emailTextField.text != "") {
                Auth.auth().currentUser?.updateEmail(to: emailTextField.text!) { (error) in
                    if let error = error {
                        print(error)
                    } else {
                        print("CHANGED Email")
                    }
                }
            }
            var updateValue = [String:String]()
            if (fullNameTextField.text == "") {
                updateValue = [
                    "fullname": fullNameTextField.text!
                ]
            } else if (fullNameTextField.text == "") {
                updateValue = [
                    "phonenumber": phoneTextField.text!
                ]
            } else {
                updateValue = [
                    "fullname": fullNameTextField.text!,
                    "phonenumber": phoneTextField.text!
                ]
            }
            self.ref.child("users").child(self.uid!).updateChildValues(updateValue)
        }
    }
    
    // check if it's valid phone number
    // Reference: https://stackoverflow.com/questions/53427424/how-to-validate-american-phone-format-in-swift-4
    func isValidMobile(testStr:String) -> Bool {
        let mobileRegEx = "(\\([0-9]{3}\\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}"
        let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
        return mobileTest.evaluate(with: testStr)
    }
    
    // sending data to next view controller
    // reference: https://www.youtube.com/watch?v=uKQjJb-KSwU
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "nextStep") {
            var vc = segue.destination as! ChangeAddressViewController
            vc.fullName = self.fullNameTextField.text!
        }
    }
    
    @objc func resetPasswordButtonTapped() {
        let changeViewController = ChangePasswordViewController()
        self.present(changeViewController, animated: true, completion: nil)
    }
    
    // handle sign out button
    @IBAction func SignOutButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Sign Out", message: "Are you sure that you sign out?", preferredStyle: .alert)
        let signout = UIAlertAction(title: "Sign Out", style: .default) { (action:UIAlertAction) in
            do {
                try Auth.auth().signOut()
                if let storyboard = self.storyboard {
                    let vc = storyboard.instantiateViewController(withIdentifier: "InitialViewController")
                    self.present(vc, animated: false, completion: nil)
                }
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


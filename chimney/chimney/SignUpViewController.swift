//
//  SignUpViewController.swift
//  chimney
//
//  Created by Kangwoo on 3/2/19.
//  Copyright © 2019 chimney. All rights reserved.
//
//

import Foundation
import UIKit
import FirebaseAuth // for authenication
import Firebase

// Reference: https://stackoverflow.com/questions/1246439/uitextfield-for-phone-number
class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var myPhoneNumber = String()
    // text fields
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    // database reference
    var ref: DatabaseReference!
    var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize the reference
        ref = Database.database().reference()
        phoneTextField.delegate = self
        phoneTextField.keyboardType = .phonePad
    }
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.phoneTextField) && textField.text == ""{
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
    
    // after tapping sign up button
    // reference: https://stackoverflow.com/questions/53628375/how-to-store-user-data-in-ios-firebase-with-swift-4
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        // if there is an empty space on each field, return the alert.
//        print(fullNameTextField.text)
        let errorString = "Error"
        if fullNameTextField.text == ""  {
//            print("Debug1")
            let alertController = UIAlertController(title: errorString, message: "you should type the full name", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
            
        } else if self.emailTextField.text == "" {
//            print("Debug2")
            let alertController = UIAlertController(title: errorString, message: "you should type the email", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if self.passwordTextField.text == nil || confirmPasswordTextField.text == nil {
//            print("Debug3")
            let alertController = UIAlertController(title: errorString, message: "you should type the password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if self.passwordTextField.text != self.confirmPasswordTextField.text {
//            print("Debug4")
            let alertController = UIAlertController(title: errorString, message: "you should confirm password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if self.phoneTextField == nil {
            let alertController = UIAlertController(title: errorString, message: "you type phone number", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if isValidMobile(testStr: self.phoneTextField.text!) {
            let alertController = UIAlertController(title: errorString, message: "Type valid phone number", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else {
            // create user on Firebase
//            print("Debug5")
            Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
                    let userData = ["phone": self.phoneTextField.text,
                                    "fullname": self.fullNameTextField.text]
                    self.ref.child("users").child(user!.user.uid).setValue(userData)
                    self.performSegue(withIdentifier: "nextStep", sender: self)
                } else {
                    print("Debug " + error!.localizedDescription)
                    let alertController = UIAlertController(title: errorString, message: error!.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // check if it's valid phone number
    // Reference: https://stackoverflow.com/questions/53427424/how-to-validate-american-phone-format-in-swift-4
    func isValidMobile(testStr:String) -> Bool {
        let mobileRegEx = "(\\([0-9]{3}\\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}"
        let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
        return mobileTest.evaluate(with: testStr)
    }
    
//     sending data to next view controller
//     reference: https://www.youtube.com/watch?v=uKQjJb-KSwU
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "nextStep") {
            var vc = segue.destination as! AddAddressViewController
            vc.fullName = self.fullNameTextField.text!
        }
    }
    
}

extension UITextFieldDelegate {
    func phoneMask(phoneTextField: UITextField, textField: UITextField, _ range: NSRange, _ string: String) -> (result: Bool, phoneNumber: String, maskPhoneNumber: String) {
        let oldString = textField.text!
        let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
        //in numString only Numeric characters
        let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let numString = components.joined(separator: "")
        
        let length = numString.count
        let maxCharInPhone = 11
        
        if newString.count < oldString.count { //backspace to work
            if newString.count <= 2 { //if now "+7(" and push backspace
                phoneTextField.text = ""
                return (false, "", "")
            } else {
                return (true, numString, newString) //will not in the process backspace
            }
        }
        
        if length > maxCharInPhone { // input is complete, do not add characters
            return (false, numString, newString)
        }
        var indexStart, indexEnd: String.Index
        var maskString = "", template = ""
        var endOffset = 0
        
        if newString == "+" { // allow add "+" if first Char
            maskString += "+"
        }
        //format +X(XXX)XXX-XXXX
        if length > 0 {
            maskString += "+"
            indexStart = numString.index(numString.startIndex, offsetBy: 0)
            indexEnd = numString.index(numString.startIndex, offsetBy: 1)
            maskString += String(numString[indexStart..<indexEnd]) + "("
        }
        if length > 1 {
            endOffset = 4
            template = ")"
            if length < 4 {
                endOffset = length
                template = ""
            }
            indexStart = numString.index(numString.startIndex, offsetBy: 1)
            indexEnd = numString.index(numString.startIndex, offsetBy: endOffset)
            maskString += String(numString[indexStart..<indexEnd]) + template
        }
        if length > 4 {
            endOffset = 7
            template = "-"
            if length < 7 {
                endOffset = length
                template = ""
            }
            indexStart = numString.index(numString.startIndex, offsetBy: 4)
            indexEnd = numString.index(numString.startIndex, offsetBy: endOffset)
            maskString += String(numString[indexStart..<indexEnd]) + template
        }
        var nIndex: Int; nIndex = 7
        //            //format +X(XXX)XXX-XX-XX  -> if need uncoment
        //            nIndex = 9
        //
        //            if length > 7 {
        //                endOffset = 9
        //                template = "-"
        //                if length < 9 {
        //                    endOffset = length
        //                    template = ""
        //                }
        //                indexStart = numString.index(numString.startIndex, offsetBy: 7)
        //                indexEnd = numString.index(numString.startIndex, offsetBy: endOffset)
        //                maskString += String(numString[indexStart..<indexEnd]) + template
        //            }
        if length > nIndex {
            indexStart = numString.index(numString.startIndex, offsetBy: nIndex)
            indexEnd = numString.index(numString.startIndex, offsetBy: length)
            maskString += String(numString[indexStart..<indexEnd])
        }
        phoneTextField.text = maskString
        if length == maxCharInPhone {
            //dimiss kayboard
            phoneTextField.endEditing(true)
            return (false, numString, newString)
        }
        return (false, numString, newString)
    }
}

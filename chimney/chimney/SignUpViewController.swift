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
import Firebase
import CommonCrypto

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
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
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
        if self.fullNameTextField.isEmpty {
            createAlertController("You should type your full name")
        } else if self.emailTextField.isEmpty {
            createAlertController("You should type email")
        } else if self.passwordTextField.isEmpty {
            createAlertController("You should type password")
        } else if self.confirmPasswordTextField.isEmpty {
            createAlertController("You should type password confirmation")
        } else if self.phoneTextField.isEmpty {
            createAlertController("You should type your phone")
        } else if isValidMobile(testStr: self.phoneTextField.text!) {
            createAlertController("You should type valid phone number")
        } else if self.passwordTextField.text != self.confirmPasswordTextField.text {
            createAlertController("You should match password with confirmed password")
        } else {
            // create user on Firebase
            Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
//                    let md5Data = self.MD5(string:self.emailTextField.text!)
//                    let md5Hex = md5Data!.map { String(format: "%02hhx", $0) }.joined()
                    let userData = ["phone": self.phoneTextField.text,
                                    "fullname": self.fullNameTextField.text,
                                    "email": self.emailTextField.text,
                                    ]
                    self.ref.child("users").child(user!.user.uid).setValue(userData)
                    self.performSegue(withIdentifier: "nextStep", sender: self)
                } else {
                    print("Debug " + error!.localizedDescription)
                    self.createAlertController(error!.localizedDescription)
                }
            }
        }
    }
    
    // Refactor for creating alertcontroller when error occurs
    func createAlertController(_ msg: String) {
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alertController, animated: true, completion: nil)
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
    
//    // Reference: https://github.com/hakanozer/GravatarSwift/blob/master/GravatarSwift/Profile.swift
//    func MD5(string: String) -> Data? {
//        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
//        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
//        _ = digestData.withUnsafeMutableBytes {digestBytes in
//            messageData.withUnsafeBytes {messageBytes in
//                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
//            }
//        }
//        return digestData
//    }
}

// to check whether the textfield is empty or not
// https://stackoverflow.com/questions/52139322/elegant-way-to-check-if-uitextfield-is-empty
// https://stackoverflow.com/questions/24102641/how-to-check-if-a-text-field-is-empty-or-not-in-swift
extension UITextField {
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
}

// Reference: https://stackoverflow.com/questions/1246439/uitextfield-for-phone-number
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

//
//  ReviewInfoController.swift
//  chimney
//
//  Created by Ziyi Zhuang on 5/15/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import Foundation

import UIKit
import Firebase

class ReviewInfoController: UIViewController {
    @IBAction func cancel(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            self.performSegue(withIdentifier: "back", sender: self)
        }
        
        let action2 = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed no");
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        
        
        present(alertController, animated: true, completion: nil)
    }
}

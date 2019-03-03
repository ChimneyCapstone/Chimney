//
//  ReviewViewController.swift
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
class ReviewViewController: UIViewController {
    @IBOutlet weak var ReviewTableView: UITableViewCell!

    @IBOutlet weak var MyNeighborsButoon: UISegmentedControl!
    
    @IBOutlet weak var MyRequestButton: UISegmentedControl!
    

    
    @IBAction func MyRequestsButtonTapped(_ sender: UISegmentedControl) {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Requests from my neighbors"
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellReuseIdentifier", for: indexPath)
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
            ref.child("users").child("1XrCfEdrhFageQnLnshRLXiPXaO2").child("request").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? String
                cell.textLabel?.text = value
                
            }) { (error) in
                print(error.localizedDescription)
            }
            return cell
        }
    }

    
}

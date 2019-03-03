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

//    @IBOutlet weak var MyNeighborsButoon: UISegmentedControl!
    
//    @IBOutlet weak var MyRequestButton: UISegmentedControl!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func calculateButton(_ sender: UISegmentedControl) {
        let index = segmentedControl.selectedSegmentIndex
        if index == 1 {
            
            func numberOfSections(in ReviewTableView: UITableView) -> Int {
                return 1
            }
            
            func ReviewTableView(_ ReviewTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return 5
            }
            
            func ReviewTableView(_ ReviewTableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                return "Requests from my neighbors"
            }
            func ReviewTableView(_ ReviewTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = ReviewTableView.dequeueReusableCell(withIdentifier: "CellReuseIdentifier", for: indexPath)
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
        //...
    }
//    @IBAction func MyRequestsButtonTapped(_ sender: UISegmentedControl) {
//
//    }

    
}

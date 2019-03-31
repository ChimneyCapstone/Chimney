//
//  ReviewViewController.swift
//  chimney
//
//  Created by Ziyi Zhuang on 3/2/19
//  Changed by Kangwoo Choi on 3/30/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMaps

// This class is the view controller of reviewing requests that a user ask and received
// Reference: https://www.youtube.com/watch?v=zPF_kFn8mBA
// https://iosdevcenters.blogspot.com/2018/05/adding-segmented-control.html

class ReviewViewController: UIViewController {
    
    var user: User?
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Review"
        ref = Database.database().reference()
        // create segmentControl and add to view controller
        let segmentedControl = createSegment()
        self.view.addSubview(segmentedControl)
        
        user = verifiedUser(user: Auth.auth().currentUser!)
        self.getRequestInfo()
        // set default swipe direction
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        // add left swipe motion
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(leftSwipe)
        
    }
    
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
    
    // create segmentControl and add to view controller
    func createSegment() -> UISegmentedControl {
        let items = ["Asked", "Took"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.center = self.view.center
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(ReviewViewController.indexChanged(_:)), for: .valueChanged)
        
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.backgroundColor = .red
        segmentedControl.tintColor = .yellow
        
        return segmentedControl
    }
    
    // add function when tap controller
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            print("Asked");
        case 1:
            print("Took")
        default:
            break
        }
    }
    
    // handle swipe motion
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .right:
                print("right")
            case .left:
                print("left")
            default:
                break
            }
        }
    }
    
    // get requests from other users and address from firebase real-time database
    func getRequestInfo() {
        //
        self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
//                let key = snap.key
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshots {
                        if (snap.value as? Dictionary<String, AnyObject>) != nil {
                            let key = snap.key
                            
                            print(value)
                            
                        }
                    }
                }
            }
        })
    }
    
}

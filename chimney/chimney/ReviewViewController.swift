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
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Review"
        ref = Database.database().reference()
        // create segmentControl and add to view controller
//        let segmentedControl = createSegment()
//        self.view.addSubview(segmentedControl)
        
        user = verifiedUser(user: Auth.auth().currentUser!)
        self.uid = self.user?.uid
        self.getRequestInfo()
        // set default swipe direction
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        // add left swipe motion
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(leftSwipe)
        
    }
    
    // create segment control and add to view controller
//    func createSegment() -> UISegmentedControl {
//        let items = ["Asked", "Took"]
//        let segmentedControl = UISegmentedControl(items: items)
//        segmentedControl.center = self.view.center
//        segmentedControl.selectedSegmentIndex = 0
//        segmentedControl.addTarget(self, action: #selector(ReviewViewController.indexChanged(_:)), for: .valueChanged)
//
//        segmentedControl.layer.cornerRadius = 5.0
//        segmentedControl.backgroundColor = .red
//        segmentedControl.tintColor = .yellow
//
//        return segmentedControl
//    }
    
    // animation for segment control
//    @objc func indexChanged(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex{
//        case 0:
//            print("Asked");
//        case 1:
//            print("Took")
//        default:
//            break
//        }
//    }
    
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
    // extremely slow... and not able to get a user's request...
    func getRequestInfo() -> [ Request ] {
        var requestArr: [ Request ] = []
        
        let requestRef = self.ref.child("users").child(self.uid!).child("request")
        requestRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if (!snapshot.exists()) {
                return
            }
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                let address =  self.getAddress(key: key)
                var amount: String?
                var task: String?
                if (address == "") {
                    return
                }
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshots {
                        if (snap.value as? Dictionary<String, AnyObject>) != nil {
//                            let key = snap.key
                            let value = snap.value as? Dictionary<String, AnyObject>
                            if value?["request"] != nil {
                                let content = value?["request"] as? Dictionary<String, Dictionary<String, String>>
                                let val = content!.values
                                for a in val {
                                    amount = a["amount"]!
                                    task = a["task"]!
                                }
                                let r = Request.init(address: address, task: task!, amount: amount!)
                                requestArr.append(r)
                            }
                        }
                    }
                }
                
            }
        })
        
        return requestArr
    }
    
    func getAddress(key: String) -> String {
        let addressRef = self.ref.child("users").child(self.uid!).child("address")
        var address = ""
        addressRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                address += snap.value as! String
                address += ", "
            }
        })
        return String(address.dropLast().dropLast())
    }
}

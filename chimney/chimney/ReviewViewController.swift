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


// This class is the view controller of sign-up page
class ReviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        addControl()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "PlainCell")
        return cell
    }

    func addControl() {
        let segmentItems = ["Neighbors", "Mine"]
        let control = UISegmentedControl(items: segmentItems)
        control.frame = CGRect(x: 10, y: 100, width: (self.view.frame.width - 20), height: 50)
        control.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 1
        view.addSubview(control)
        
    }
    
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        // neighbors
        case 0:
//            var ref: DatabaseReference!
//            ref = Database.database().reference().child("users");
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                for child in snapshot.children {
//                    let snap = child as! DataSnapshot
//                    let key = snap.key
//                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//                        for snap in snapshots {
//                            if (snap.value as? Dictionary<String, AnyObject>) != nil {
//                                let key = snap.key
//                                let value = snap.value as? Dictionary<String, AnyObject>
//                                if value?["request"] != nil {
//                                    let content = value?["request"] as? Dictionary<String, Dictionary<String, String>>
//                                    let val = content!.values
//                                    for (a) in content!{
//                                        let id = a.key
//                                        var mission = a.value
//                                        let uid = Auth.auth().currentUser!.uid
//                                        // do not render task that are already picked up by someone
//                                        // do not render task that I posted myself
//                                        if (mission["picker"] != nil || key == uid) {
//                                            break;
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            })
            
            break
        // my requests
        case 1:
            // Second segment tapped
            var ref: DatabaseReference!
            let uid = Auth.auth().currentUser!.uid
            ref = Database.database().reference().child("users").child(uid);
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot.value)
            })


            break
        default:
            break
        }
    }
}

    
    


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
    
    var contents:[String] = []
    var index = -1

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        super.viewDidLoad()

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "PlainCell")
        addControl()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            print(self.contents)

            if self.index < self.contents.count {
                self.index+=1
                cell.textLabel?.text = self.contents[self.index]
            }
        }
        return cell
    }

    func addControl() {
        let segmentItems = ["Neighbors", "Mine"]
        let control = UISegmentedControl(items: segmentItems)
        control.frame = CGRect(x: 10, y: 100, width: (self.view.frame.width - 20), height: 50)
        control.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
//        control.selectedSegmentIndex = 1
        view.addSubview(control)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func segmentControl( _ segmentedControl: UISegmentedControl) {
        print(segmentedControl.selectedSegmentIndex)
        switch (segmentedControl.selectedSegmentIndex) {
        // neighbors' requests
        case 0:
            var ref: DatabaseReference!
            let uid = Auth.auth().currentUser!.uid
            ref = Database.database().reference().child("users").child(uid).child("request");
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        for snap in snapshots {
                            if let res =  snap.value as? Dictionary<String,String>  {
                                var context: String = "";
                                for info in res {
                                    context.append(info.key + "\t" + info.value + "\t")
                                }
                                //                                print(self.contents)
                                self.contents.append(context)
                            }
                        }
                    }
                }
            })
            break
        // my requests
        case 1:
            // Second segment tapped
            var ref: DatabaseReference!
            let uid = Auth.auth().currentUser!.uid
            ref = Database.database().reference().child("users").child(uid).child("request");
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        for snap in snapshots {
                            if let res =  snap.value as? Dictionary<String,String>  {
                                var context: String = "";
                                for info in res {
                                    context.append(info.key + "\t" + info.value + "\t")
                                }
//                                print(self.contents)
                                self.contents.append(context)
                            }
                        }
                    }
                }
            })
            break
        default:
            var ref: DatabaseReference!
            let uid = Auth.auth().currentUser!.uid
            ref = Database.database().reference().child("users").child(uid).child("request");
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        for snap in snapshots {
                            if let res =  snap.value as? Dictionary<String,String>  {
                                var context: String = "";
                                for info in res {
                                    context.append(info.key + "\t" + info.value + "\t")
                                }
                                print(self.contents)
                                self.contents.append(context)
                            }
                        }
                    }
                }
            })
            break
        }
    }
}

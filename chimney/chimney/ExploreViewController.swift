//
//  ExploreViewController.swift
//  chimney
//
//  Created by Ziyi Zhuang on 3/1/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import Foundation
import UIKit
import Firebase


//class ExploreViewController: UIViewController, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 7
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//
//        var ref: DatabaseReference!
////        let uid = Auth.auth().currentUser!.uid
//        ref = Database.database().reference().child("users");
//        ref.observeSingleEvent(of: .value) { snapshot in
//            print(snapshot)
//            print(snapshot.childrenCount) // I got the expected number of items
//            let enumerator = snapshot.children
//            while let rest = enumerator.nextObject() as? DataSnapshot {
//                print(rest.value)
//                cell.textLabel?.text = rest.value as! String;
//            }
//        }
//
////        cell.addSubview(label)
//        return cell
//
//    }
//
//
//    @IBOutlet weak var ExploreTableView: UITableView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        navigationItem.title = quake.place
//
////        ExploreTableView.datasource = self
//    }
//
//
//}

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sections = ["Fruit", "Vegetables"]
    let fruit = ["Apple", "Orange", "Mango"]
    let vegetables = ["Carrot", "Broccoli", "Cucumber"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
//        case 0:
//            // Fruit Section
//            return fruit.count
//        case 1:
//            // Vegetable Section
//            return vegetables.count
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an object of the dynamic cell "PlainCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        // Depending on the section, fill the textLabel with the relevant text
        var ref: DatabaseReference!
        ref = Database.database().reference().child("users");
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshots {
                        if (snap.value as? Dictionary<String, AnyObject>) != nil {
                            let key = snap.key
                            let value = snap.value as? Dictionary<String, AnyObject>
                            if value?["request"] != nil {
                                let content = value?["request"] as? Dictionary<String, Dictionary<String, String>>
                                print(content!.values)
                                let val = content!.values
                                for (a) in val{
                                    let task = "amount $: \(a["amount"]!)    task:  \(a["task"]!)";
                                    cell.textLabel?.text = task
                                }
                            }
                        }
                    }
                }
            }
        });
        return cell
    }
}

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
    
    var contents:[String] = []
    var index = -1
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.

        super.viewDidLoad()

    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return "Requests"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func loadInfo(){
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
                                let val = content!.values
                                for (a) in val{
                                    let task: String = "amount $: \(a["amount"]!)    task:  \(a["task"]!)";
                                    self.contents.append(task)
//                                    print(self.contents)
                                }
                            }
                        }
                    }
                }
            }
            
      });
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an object of the dynamic cell "PlainCell"
        self.index+=1
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        // Depending on the section, fill the textLabel with the relevant text
        
        loadInfo()
        print("second")
//        print(self.index)
//        print(whole)
        if self.index < self.contents.count {
            cell.textLabel?.text = self.contents[self.index]
            print(self.contents[self.index])
        }
        return cell

    }
}

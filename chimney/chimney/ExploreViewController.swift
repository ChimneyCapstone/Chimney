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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        // Create an object of the dynamic cell "PlainCell"
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
                                }
                            }
                        }
                    }
                }
            }
            
        });
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.index < self.contents.count {
                self.index+=1
                cell.textLabel?.text = self.contents[self.index]

            }
        }
        return cell


    }
}

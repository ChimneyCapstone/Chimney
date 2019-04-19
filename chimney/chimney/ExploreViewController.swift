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
    
    var contents:[[String]] = []
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
        var cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "PlainCell")
        
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
//                            print(key)
                            let value = snap.value as? Dictionary<String, AnyObject>
                            if value?["request"] != nil {
                                let content = value?["request"] as? Dictionary<String, Dictionary<String, String>>
                                let val = content!.values
                                for (a) in content!{
                                    let id = a.key
                                    let mission = a.value
//                                    let task: String = "id: \(id)  amount $: \(mission["amount"]!)    task:  \(mission["task"]!)";
                                    var task:[String]=[]
                                    task.append("amount $: \(mission["amount"]!)    task:  \(mission["task"]!)")
                                    task.append("poster:\(key) taskId:\(id)")
                                    self.contents.append(task)
                                }
                            }
                        }
                    }
                }
            }
            
        });
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.index < self.contents.count {
                self.index+=1
                cell.textLabel?.text = self.contents[self.index][0]
                cell.detailTextLabel?.text = self.contents[self.index][1]
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow

        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell

        //getting the text of that cell
        let currentItem: String = currentCell.textLabel!.text!
        let detail: String = currentCell.detailTextLabel!.text!
        
        let alertController = UIAlertController(title: "Are you sure you want to pick up the Request?", message: "You Selected " + currentItem , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Yes", style: .default,
                                          handler:
            { action in
                var ref: DatabaseReference!
                // current user is the user who picked up the task
                let uid = Auth.auth().currentUser!.uid
                ref = Database.database().reference().child("users").child(uid).child("pickedup");
                ref.childByAutoId().setValue(currentItem)
                
                
                // how to get the user who posted the task????
                // .....
                var infoArr = detail.components(separatedBy: " ")
                //        var refe: DatabaseReference!
                print(infoArr)
                print(infoArr[0])
                let posterId: String = String(infoArr[0].dropFirst(8))
                let taskId: String = String(infoArr[1].dropFirst(8))
                print(posterId)
                print(taskId)
                //        var update = [String: String]()
                //        update.
                var refe: DatabaseReference!

                refe = Database.database().reference().child("users").child(posterId).child("request").child(taskId)
//                refe.updateChildValues({"picker": uid})
                

        }
                )
        alertController.addAction(defaultAction)

        present(alertController, animated: true, completion: nil)
    }
    
    // function to handle the back end to connect the requester's task to the one who picks up
    // needs to update the task with the name who picks it up
    // (current design, under each task, put whoever picked up's name)
//    func pickUpHandler(currentItem: String, detail: String)(alertAction:UIAlertAction) -> () {
//        var ref: DatabaseReference!
//        // current user is the user who picked up the task
//        let uid = Auth.auth().currentUser!.uid
//        ref = Database.database().reference().child("users").child(uid).child("pickedup");
//        ref.childByAutoId().setValue(currentItem)
//
//
//        // how to get the user who posted the task????
//        // .....
//        var infoArr = detail.components(separatedBy: "\\t")
////        var refe: DatabaseReference!
//        let posterId: String = String(infoArr[0].dropFirst(8))
//        let taskId: String = String(infoArr[1].dropFirst(8))
//        print(posterId)
//        print(taskId)
////        var update = [String: String]()
////        update.
//        Database.database().reference().child("users").child(posterId).child("request").child(taskId).updateChildValues(["picker": uid])
//
//    }
}

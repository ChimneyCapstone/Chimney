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
import CoreLocation


// This class is the view controller of sign-up page
class ReviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var contents:[String] = []
    var neighborReq:[String] = [];
    var index = -1
    var curSeg = -1;

    @IBOutlet weak var control: UISegmentedControl!
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {

        }
        return self.contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "PlainCell")
//        addControl()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            switch(self.curSeg) {
            case 0:
                print("yoyo")
                print(self.neighborReq.count - 1)

                if self.index < self.neighborReq.count - 1 {
                    self.index+=1
                    cell.textLabel?.text = self.neighborReq[self.index]
                }
            case 1:
                if self.index < self.contents.count {
                    self.index+=1
                    cell.textLabel?.text = self.contents[self.index]
                }
            default:
                cell.textLabel?.text = "please wait"

            }
        }
        return cell
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl)
    {
        self.index = 0
        self.tableView.reloadData()
    }
    
    func addControl() {
        let segmentItems = ["Neighbors", "Mine"]
        let control = UISegmentedControl(items: segmentItems)
        control.frame = CGRect(x: 10, y: 100, width: (self.view.frame.width - 20), height: 50)
        control.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        view.addSubview(control)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func segmentControl( _ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        // neighbors' requests
        case 0:
            neighborReq.append("amount 4   task starbucks")
            neighborReq.append("amount 11   task icecream")
            neighborReq.append("amount 10   task kfc")
            self.curSeg = 0

            var ref: DatabaseReference!
            let uid = Auth.auth().currentUser!.uid
            ref = Database.database().reference().child("users").child(uid).child("address");
            var myAddr = "";
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if (snapshot.value as? Dictionary<String, AnyObject>) != nil {
                    let snap = snapshot.value as? Dictionary<String, AnyObject>
                    for child in snap! {
                        myAddr.append(" " + (child.value as! String) as! String);
                    }
                }
            })
            var lat: CLLocationDegrees?;
            var lon: CLLocationDegrees?;
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(myAddr) {
                    placemarks, error in
                    let placemark = placemarks?.first
                    lat = placemark?.location?.coordinate.latitude
                    lon = placemark?.location?.coordinate.longitude
                    print("Lat: \(lat), Lon: \(lon)")
                }
            }


            // loop through all users and look for requests(no pickedup field) and address 10 min away
            var refe: DatabaseReference!
            refe = Database.database().reference().child("users")
            refe.observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        for snap in snapshots {
                            if (snap.value as? Dictionary<String, AnyObject>) != nil {
                                let key = snap.key
                                if (key != uid) {
                                    let value = snap.value as? Dictionary<String, AnyObject>
                                    // getting request
                                    for add in value! {
//                                        if (add.key == "request") {
//                                            if (add.value as? Dictionary<String, AnyObject>) != nil {
//                                                let req = add.value as? Dictionary<String, AnyObject>
//                                                for child in req! {
//                                                    let content = req as? Dictionary<String, Dictionary<String, String>>
//                                                    let val = content!.values
//                                                    print("here")
//                                                    print(val)
//                                                    for (a) in content!{
////                                                        print(a)
//                                                        let tasks = a.value as? Dictionary<String, AnyObject>
////                                                        print(tasks)
//                                                        var cur = "";
//                                                        for task in tasks! {
//                                                            if (task.key != "picker") {
//                                                                cur.append(task.value as! String);
//                                                            } else{
//                                                                break;
//                                                            }
//                                                        }
////                                                        print(cur)
//                                                    }
//                                                }
//                                            }
//
                                        
                                        var otherAddress = "";
                                        if (add.key == "address") {
                                            if (add.value as? Dictionary<String, AnyObject>) != nil {

                                                let otherAdd = add.value as? Dictionary<String, AnyObject>
                                                for child in otherAdd! {
                                                    otherAddress.append(" " + (child.value as! String) as! String);
                                                }
                                            }
                                        }
                                        var lat2: CLLocationDegrees?;
                                        var lon2: CLLocationDegrees?;
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                            let geoCoder = CLGeocoder()
                                            geoCoder.geocodeAddressString(otherAddress) {
                                                placemarks, error in
                                                let placemark = placemarks?.first
                                                lat2 = placemark?.location?.coordinate.latitude
                                                lon2 = placemark?.location?.coordinate.longitude
                                                print("Lat2: \(lat), Lon2: \(lon)")
                                            }
                                        }
                                        if (lat2 == nil || lon2 == nil) {
                                            break;
                                        }
                                        let startLocation = CLLocation(latitude: lat!, longitude: lon!)
                                        let endLocation = CLLocation(latitude: lat2!, longitude: lon2!)
                                        let distance: CLLocationDistance = startLocation.distance(from: endLocation)
                                        // in meters
                                        if (distance < 10000) {
                                            // yes, neighbors
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            });
            break
        // my requests
        case 1:
            
            self.curSeg = 1
            // Second segment tapped
            if(self.contents == []){
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
                                        if (info.key == "picker") {
//                                            context = "";
                                            break
                                        }
                                        // picker
                                        context.append(info.key + "\t" + info.value + "\t")
                                    }
                                    self.contents.append(context)
                                }
                            }
                        }
                    }
                })
                break
            }
        default:
            if (self.contents == []) {
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
    
    // deal with the row selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        //getting the text of that cell
        if (currentCell.textLabel != nil && currentCell.textLabel!.text != nil) {
            let currentItem: String = currentCell.textLabel!.text!
    //        let detail: String = currentCell.detailTextLabel!.text!
            

            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
                // delete row
                print("toto")
                self.contents.remove(at: indexPath!.row)
                print("here")
                self.tableView.deleteRows(at: [indexPath!], with: .automatic)


            }
            
            let action2 = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
                print("You've pressed no");
            }
            
            alertController.addAction(action1)
            alertController.addAction(action2)

            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func ProfileButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "profile", sender: self)
    }
}


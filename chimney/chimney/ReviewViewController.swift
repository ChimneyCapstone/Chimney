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

        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0) {
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
                print(myAddr)
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
                                    for add in value! {
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
                                            print(otherAddress)
                                            geoCoder.geocodeAddressString(otherAddress) {
                                                placemarks, error in
                                                let placemark = placemarks?.first
                                                lat2 = placemark?.location?.coordinate.latitude
                                                lon2 = placemark?.location?.coordinate.longitude
                                                print("Lat2: \(lat), Lon2: \(lon)")
                                            }
                                        }
                                        var startLocation = CLLocation(latitude: lat!, longitude: lon!)
                                        var endLocation = CLLocation(latitude: lat2!, longitude: lon2!)
                                        var distance: CLLocationDistance = startLocation.distance(from: endLocation)
                                        // in meters
                                        if (distance < 10000) {
                                            // considered neighbors
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

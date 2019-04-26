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
        case 0:
            print("1")
            break
        case 1:
            // Second segment tapped
            print("2")

            break
        default:
            break
        }
    }
}

    
    


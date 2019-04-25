//
//  TableViewController.swift
//  chimney
//
//  Created by Ziyi Zhuang on 3/1/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var TableView: UITableViewCell!
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Request list"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellReuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = "Task"
        
        return cell
    }
    
}

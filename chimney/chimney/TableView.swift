//
//  TableView.swift
//  chimney
//
//  Created by Ziyi Zhuang on 3/1/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//class TableView: UIViewController, UITableViewDataSource {
//    import UIKit

class TableViewController: UIViewController, UITableViewDataSource {
        
//    @IBOutlet var tableView: UITableView!
    // MARK: - Table view data source
        
    @IBOutlet weak var tableView: UIView!
    func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Section \(section)"
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellReuseIdentifier", for: indexPath)
            
            cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
            
            return cell
        }
        
}


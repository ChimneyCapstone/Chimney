//
//  SecondTabViewController.swift
//  chimney
//
//  Created by Ziyi Zhuang on 4/26/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import Foundation
import UIKit

class SecondTabViewController: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Second VC will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Second VC will disappear")
    }
}

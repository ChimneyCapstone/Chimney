//
//  InfoViewController.swift
//  chimney
//
//  Created by Ziyi Zhuang on 5/17/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import Foundation
import UIKit

class InfoViewController: UIViewController{
    
    @IBAction func MapButtonTapped(_ sender: UIButton) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=47.6593549,-122.30366374805264&directionsmode=driving")! as URL)

        } else {
            NSLog("Can't use comgooglemaps://");
        }
    }
}


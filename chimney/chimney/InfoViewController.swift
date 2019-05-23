//
//  InfoViewController.swift
//  chimney
//
//  Created by Ziyi Zhuang on 5/17/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
class InfoViewController: UIViewController{
    
    @IBAction func MapButtonTapped(_ sender: UIButton) {
        let latitude: CLLocationDegrees = 47.6062
        let longitude: CLLocationDegrees = 122.3321
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Dave's place"
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func MessageButtonTapped(_ sender: UIButton) {
//        if UIApplication.shared.canOpenURL(URL(string:"sms:2062281234")!) {
//            UIApplication.shared.open(URL(string:"sms:2062281234")!, options: [:], completionHandler: nil)
//        }
        let sms: String = "sms:2061231231&body=Hello, I am on my way."
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
}

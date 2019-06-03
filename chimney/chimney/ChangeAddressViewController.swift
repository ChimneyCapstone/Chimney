//
//  ChangeAddressViewController.swift
//  chimney
//
//  Created by Kangwoo on 4/25/19.
//  Copyright © 2019 chimney. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces // for address autocompleting options


import UIKit
import GooglePlaces

class ChangeAddressViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var ref: DatabaseReference!
    var fullName: String = ""
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        ref = Database.database().reference()
        welcomeLabel.text = "Welcome! " + fullName + "\nChange your Home address!"
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
}

// Handle the user's selection.
extension ChangeAddressViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        //        print("Place name: \(place.name)")
        //        print("Place address: \(place.formattedAddress)")
        //        print("Place attributions: \(place.attributions)")
        let alertController = UIAlertController(title: "Confirmation", message: "Your address is \n" + place.formattedAddress!, preferredStyle: .alert)
        // US address only
        alertController.addAction(UIAlertAction(title: "Let's start!", style:.default, handler: { _ in
            let arr = place.formattedAddress!.components(separatedBy: ",")
            let city = arr[1].replacingOccurrences(of: " ", with: "")
            let stateAndzip = arr[2].components(separatedBy: " ")
            let state = stateAndzip[1]
            let zipcode = stateAndzip[2]
            let userData = [
                "address": place.name!,
                "city": city,
                "state": state,
                "zipcode": zipcode
            ]
            self.ref.child("users").child(Auth.auth().currentUser!.uid).child("address").updateChildValues(userData)
            // move to main view
            let vc = EditViewController()
            self.present(vc, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


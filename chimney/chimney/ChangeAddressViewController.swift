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
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        ref = Database.database().reference()
        welcomeLabel.text = "Welcome! Change your Home address!"
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
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
            if (arr.count  > 3) {
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
                // saving error
                self.ref.child("users").child(Auth.auth().currentUser!.uid).child("address").setValue(userData) {
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                    }
                }
                // move to main view
                self.performSegue(withIdentifier: "pathToHome", sender: self)
            } else {
                let errorAlertController = UIAlertController(title:"Error", message: "You should set address with zipcode!", preferredStyle: .alert)
                errorAlertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(errorAlertController, animated: true, completion: nil)
            }
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


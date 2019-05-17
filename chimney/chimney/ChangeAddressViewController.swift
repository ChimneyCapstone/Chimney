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
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var ref: DatabaseReference!
    var fullName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize the database reference
        ref = Database.database().reference()
        self.title = "Change Address"
        welcomeLabel.text = "Welcome! " + fullName + "\nChange your Home address!"
        // check whether a user logged in or not
        checkLoggedInUserStatus()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
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
        
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    // this function is for checking the user status
    // Reference: https://www.youtube.com/watch?v=Syv_5XDWPjY
    fileprivate func checkLoggedInUserStatus() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let signInViewController = SignInViewController()
                let signInNavigator = UINavigationController(rootViewController: signInViewController)
                self.present(signInNavigator, animated: true, completion: nil)
                return
            }
        }
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

//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 11/02/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit
import CoreLocation

let addLocationMapSegueIdentifier = "AddLocationMapSegue"

class FindLocationViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var linkTextField: UITextField!
    @IBOutlet private weak var findLocationButton: RoundedBorderButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Configuration
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Validations
    func isValidInput() -> Bool {
        guard let address = addressTextField.text, !address.isEmpty else {
            AlertHelper.showAlert(in: self, withTitle: "Error", message: ErrorMessage.invalidAddress.rawValue)
            return false
        }
        guard let link = linkTextField.text, !link.isEmpty && link.isValidUrl else {
            AlertHelper.showAlert(in: self, withTitle: "Error", message: ErrorMessage.invalidLink.rawValue)
            return false
        }
        return true
    }
    
    // MARK: - API Calls
    private func performForwardGeocode(with addressString: String!, onSuccess: @escaping ((_ placemark: CLPlacemark) -> ())) {
        findLocationButton.startLoading(blur: true, backgroundColor: findLocationButton.backgroundColor!, activityIndicatorViewStyle: .white, activityIndicatorColor: UIColor.white)
        CLGeocoder().geocodeAddressString(addressString) { (placemarks, error) in
            if let _ = error {
                AlertHelper.showAlert(in: self, withTitle: "Error", message: ErrorMessage.unableToFindLocationForAddress.rawValue)
            } else {
                guard let placemarks = placemarks, let firstPlaceMark = placemarks.first, placemarks.count > 0 && firstPlaceMark.location != nil else {
                    AlertHelper.showAlert(in: self, withTitle: "Error", message: ErrorMessage.noMatchingLocationFound.rawValue)
                    return
                }
                onSuccess(firstPlaceMark)
            }
            self.findLocationButton.stopLoading()
        }
    }
    
    // MARK: - IBActions
    @IBAction func cancelButtonDidReceiveTouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButtonDidReceiveTouchUpInside(_ sender: Any) {
        view.endEditing(true)
        if isValidInput() {
            performForwardGeocode(with: addressTextField.text!, onSuccess: { (placemark) in
                self.performSegue(withIdentifier: addLocationMapSegueIdentifier, sender: placemark)
            })
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addLocationMapSegueIdentifier {
            let destination = segue.destination as! AddLocationMapViewController
            destination.placemark = sender as! CLPlacemark
            destination.link = linkTextField.text!
        }
    }
    
}

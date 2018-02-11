//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 11/02/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapViewController: UIViewController {

     // MARK: - IBOutlets
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var finishButton: RoundedBorderButton!
    
    // MARK: - Properties
    var placemark: CLPlacemark!
    var link: String!
    private var location: CLLocation {
        return placemark.location!
    }
    private var mkPointAnnotation: MKPointAnnotation!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWithInitialData()
    }
    
    // MARK: - Configuration
    func configureWithInitialData() {
        guard let mkPointAnnotation = createMKPointAnnotation() else {
            AlertHelper.showAlert(in: self, withTitle: "Error", message: ErrorMessage.couldNotLoadData.rawValue, action: UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            return
        }
        self.mkPointAnnotation = mkPointAnnotation
        configureMapAndZoomToLocation()
    }
    
    // MARK: - Helpers
    func createMKPointAnnotation() ->  MKPointAnnotation? {
        guard let firstName = CurrentSessionData.shared.userData?.firstName, let lastName =  CurrentSessionData.shared.userData?.lastName else {
            return nil
        }
        let mkPointAnnotation = MKPointAnnotation()
        mkPointAnnotation.coordinate = location.coordinate
        mkPointAnnotation.title = "\(firstName) \(lastName)"
        mkPointAnnotation.subtitle = link
        return mkPointAnnotation
    }
    
    func configureMapAndZoomToLocation(){
        mapView.addAnnotation(mkPointAnnotation)
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        mapView.selectAnnotation(mkPointAnnotation, animated: true)
    }
    
    // MARK: - API Requests
    func postUserLocation() {
        finishButton.startLoading(blur: true, backgroundColor: finishButton.backgroundColor!, activityIndicatorViewStyle: .white, activityIndicatorColor: UIColor.white)
        guard let uniqueKey = CurrentSessionData.shared.userData?.key, let firstName = CurrentSessionData.shared.userData?.firstName, let lastName = CurrentSessionData.shared.userData?.lastName, let mapsString = placemark.mapString else {
            AlertHelper.showAlert(in: self, withTitle: "Error", message: ErrorMessage.couldNotLoadData.rawValue)
            return
        }
        let studentLocationRequestObject = PostStudentLocationRequestObject(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapsString, mediaURL: link, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        StudentLocationService().postStudentLocation(with: studentLocationRequestObject, success: { (postStudentLocationResponse) in
            AlertHelper.showAlert(in: self, withTitle: "Success", message: "Succesfully posted \(firstName)'s location.", action: UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.navigationController?.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: Notification.Name.didFinishPostingUserLocation, object: nil)
                })
            }))
        }, onFailure: { (serviceError) in
            AlertHelper.showAlert(in: self, withTitle: "Error", message: serviceError?.error ?? ErrorMessage.unknown.rawValue, leftAction: UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                self.postUserLocation()
            }), rightAction: UIAlertAction(title: "Ok", style: .default, handler: nil))
        }, onCompletion: {
            self.finishButton.stopLoading()
        })
    }
    
    // MARK: - IBActions
    @IBAction func finishButtonDidReceiveTouchUpInside(_ sender: Any) {
        postUserLocation()
    }

}


// MARK: - MKMapViewDelegate
extension FindLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinViewReuseIdentifier = "PinView"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinViewReuseIdentifier) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinViewReuseIdentifier)
            pinView!.pinTintColor = .red
            return pinView
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}

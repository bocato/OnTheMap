//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 10/02/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    private var mkPointAnnotations = [MKPointAnnotation]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudentLocations()
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.loadStudentLocations), name: Notification.Name.didFinishPostingUserLocation, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.didFinishPostingUserLocation, object: nil)
    }
    
    // MARK: - API Requests
    @objc func loadStudentLocations() {
        mapView.startLoading(blur: true, activityIndicatorViewStyle: .whiteLarge, activityIndicatorColor: UIColor.udacityBlue)
        StudentLocationService().getStudentLocations(success: { (studentLocations) in
            CurrentSessionData.shared.studentLocations = studentLocations
            self.configureMapAndCreateMKPointAnnotations(from: studentLocations)
        }, onFailure: { (errorResponse) in
            AlertHelper.showAlert(in: self, withTitle: "Error", message: errorResponse?.error ?? ErrorMessage.unknown.rawValue, leftAction: UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                self.loadStudentLocations()
            }), rightAction: UIAlertAction(title: "Ok", style: .default, handler: nil))
        }, onCompletion: {
            self.mapView.stopLoading()
        })
    }
    
    func doLogout() {
        view.startLoading(blur: false, activityIndicatorViewStyle: .white, activityIndicatorColor: UIColor.udacityBlue)
        SessionService().deleteSession({ (deleteSessionResponse) in
            self.dismiss(animated: true) {
                CurrentSessionData.shared.clearData()
            }
        }, onFailure: { (serviceError) in
            AlertHelper.showAlert(in: self, withTitle: "Error", message: serviceError?.error ?? ErrorMessage.unknown.rawValue, leftAction: UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                self.doLogout()
            }), rightAction: UIAlertAction(title: "Ok", style: .default, handler: nil))
        }, onCompletion: {
            self.view.stopLoading()
        })
    }
    
    // MARK: - API Parsers
    func configureMapAndCreateMKPointAnnotations(from studentLocations: [StudentInformation]?) {
        let mkPointAnnotations = createMKPointAnnotations(from: studentLocations)
        if mkPointAnnotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(mkPointAnnotations)
        }
    }
    
    func createMKPointAnnotations(from studentLocations: [StudentInformation]?) -> [MKPointAnnotation] {
        guard let studentLocations = studentLocations, studentLocations.count > 0 else { return [MKPointAnnotation]() }
        var mkPointAnnotations = [MKPointAnnotation]()
        for studentLocation in studentLocations {
            if let coordinate = studentLocation.coordinate, let firstName = studentLocation.firstName, let lastName = studentLocation.lastName, let mediaURL = studentLocation.mediaURL {
                let mkPointAnnotation = MKPointAnnotation()
                mkPointAnnotation.coordinate = coordinate
                mkPointAnnotation.title = "\(firstName) \(lastName)"
                mkPointAnnotation.subtitle = mediaURL
                mkPointAnnotations.append(mkPointAnnotation)
            }
        }
        return mkPointAnnotations
    }
    
    // MARK: - IBActions
    @IBAction func logoutButtonDidReceiveTouchUpInside(_ sender: UIButton) {
        doLogout()
    }
    
    @IBAction func refreshBarButtonItemDidReceiveTouchUpInside(_ sender: UIBarButtonItem) {
        loadStudentLocations()
    }
    
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinViewReuseIdentifier = "PinView"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinViewReuseIdentifier) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinViewReuseIdentifier)
            pinView!.pinTintColor = .red
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.detailDisclosure)
            return pinView
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotationSubtitle = view.annotation?.subtitle, let link = annotationSubtitle, control == view.rightCalloutAccessoryView, !link.isEmpty else {
            AlertHelper.showAlert(in: self, withTitle: "Error", message: ErrorMessage.couldNotOpenURL.rawValue)
            return
        }
        let url = URL(string: link)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            AlertHelper.showAlert(in: self, withTitle: "Error", message: "Sorry, we could'n open '\(link)', try again later.")
        }
    }
    
}

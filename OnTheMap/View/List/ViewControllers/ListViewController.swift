//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 10/02/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadStudentLocations()
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.loadStudentLocations), name: Notification.Name.didFinishPostingUserLocation, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.didFinishPostingUserLocation, object: nil)
    }
    
    // MARK: - Configuration
    func configureTableView() {
        tableView.estimatedRowHeight = 100
    }
    
    // MARK: - Helpers
    func handleStudentLocationsResponse(_ response: [StudentInformation]?) {
        CurrentSessionData.shared.studentLocations = response
        guard let studentLocations = response else {
            DispatchQueue.main.async {
                self.tableView.isHidden = true
                self.noDataLabel.isHidden = false
            }
            return
        }
        DispatchQueue.main.async {
            self.tableView.separatorStyle = studentLocations.count == 0 ? .none : .singleLine
            self.tableView.isHidden = studentLocations.count == 0
            self.noDataLabel.isHidden = !self.tableView.isHidden
            self.tableView.reloadData()
        }
    }
    
    // MARK: - API Requests
    @objc func loadStudentLocations() {
        tableView.startLoading(blur: true, backgroundColor: UIColor.white, activityIndicatorViewStyle: .whiteLarge, activityIndicatorColor: UIColor.udacityBlue)
        StudentLocationService().getStudentLocations(success: { (studentLocations) in
            self.handleStudentLocationsResponse(studentLocations)
        }, onFailure: { (errorResponse) in
            AlertHelper.showAlert(in: self, withTitle: "Error", message: errorResponse?.error ?? ErrorMessage.unknown.rawValue, leftAction: UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                self.loadStudentLocations()
            }), rightAction: UIAlertAction(title: "Ok", style: .default, handler: nil))
        }, onCompletion: {
            self.tableView.stopLoading()
        })
    }
    
    func doLogout() {
        view.startLoading(blur: false, activityIndicatorViewStyle: .white, activityIndicatorColor: UIColor.udacityBlue)
        SessionService().deleteSession({ (deleteSessionResponse) in
            self.dismiss(animated: true) {
                CurrentSessionData.shared.clearData()
            }
        }, onFailure: { (serviceError) in
            self.logoutButton.stopLoading()
            AlertHelper.showAlert(in: self, withTitle: "Error", message: serviceError?.error ?? ErrorMessage.unknown.rawValue, leftAction: UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                self.doLogout()
            }), rightAction: UIAlertAction(title: "Ok", style: .default, handler: nil))
        }, onCompletion: {
            self.view.stopLoading()
        })
    }
    
    // MARK: - IBActions
    @IBAction func logoutButtonDidReceiveTouchUpInside(_ sender: UIButton) {
        doLogout()
    }
    
    @IBAction func refreshBarButtonItemDidReceiveTouchUpInside(_ sender: UIBarButtonItem) {
        loadStudentLocations()
    }

}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentSessionData.shared.studentLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentLocationTableViewCell.identifier, for: indexPath) as! StudentLocationTableViewCell
        cell.configure(with: CurrentSessionData.shared.studentLocations?[indexPath.row])
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        guard let studentLocation = CurrentSessionData.shared.studentLocations?[indexPath.row], let mediaUrl = studentLocation.mediaURL, !mediaUrl.isEmpty else {
            AlertHelper.showAlert(in: self, withTitle: "Error", message: ErrorMessage.couldNotOpenURL.rawValue)
            return
        }
        let url = URL(string: mediaUrl)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            AlertHelper.showAlert(in: self, withTitle: "Error", message: "Sorry, we could'n open '\(mediaUrl)', try again later.")
        }
    }
    
}

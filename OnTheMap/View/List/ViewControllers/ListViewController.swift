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
    
    // MARK: - Properties
    private var studentLocations: [StudentInformation]? {
        didSet {
            guard let studentLocations = studentLocations else {
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
    }
    
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
    
    // MARK: - API Requests
    @objc func loadStudentLocations() {
        tableView.startLoading(blur: true, backgroundColor: UIColor.white, activityIndicatorViewStyle: .whiteLarge, activityIndicatorColor: UIColor.udacityBlue)
        StudentLocationService().getStudentLocations(success: { (studentLocations) in
            self.studentLocations = studentLocations?.sorted(by: { (studentInformation1, studentInformation2) -> Bool in
                guard let createdAt1 = studentInformation1.createdAt, let createdAt2 = studentInformation2.createdAt else {
                    return false
                }
                return createdAt1 < createdAt2
            })
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

// MARK: -
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentLocationTableViewCell.identifier, for: indexPath) as! StudentLocationTableViewCell
        cell.configure(with: studentLocations?[indexPath.row])
        return cell
    }
    
}

// MARK: -
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        guard let studentLocation = studentLocations?[indexPath.row], let mediaUrl = studentLocation.mediaURL else { return }
        let url = URL(string: mediaUrl)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            AlertHelper.showAlert(in: self, withTitle: "Error", message: "Sorry, we could'n open '\(mediaUrl)', try again later.")
        }
    }
    
}

//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 27/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: RoundedBorderButton!
    
    // MARK: - Configuration
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - Validations
    func isValidEMail() -> Bool {
        guard let email = emailTextField.text, !email.isEmpty, email.isValidEmail else { return false }
        return true
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonDidReceiveTouchUpInside(_ sender: Any) {
        
        view.endEditing(true)
        guard let email = emailTextField.text, let password = passwordTextField.text , isValidEMail() && !password.isEmpty else {
            AlertHelper.showAlert(in: self, withTitle: "Error", message: ErrorMessage.invalidEmailOrPassword.rawValue)
            return
        }
        
        loginButton.startLoading(blur: true, backgroundColor: loginButton.backgroundColor!, activityIndicatorViewStyle: .white, activityIndicatorColor: UIColor.white)
        SessionService().postSession(with: email, password: password, success: { (sessionResponse) in
            
            if let userId = sessionResponse?.account?.key {
                UserService().getUser(with: userId, success: { (user) in
                    guard let _ = user else {
                        AlertHelper.showAlert(in: self, withTitle: "Error", message: ErrorMessage.couldNotLoadUserData.rawValue)
                        return
                    }
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "SegueToTabBar", sender: self)
                    }
                }, onFailure: { (serviceResponse) in
                    AlertHelper.showAlert(in: self, withTitle: "Error", message: serviceResponse?.serviceError?.error ?? ErrorMessage.unknown.rawValue)
                }, onCompletion: {
                    self.loginButton.stopLoading()
                })
            } else {
                AlertHelper.showAlert(in: self, withTitle: "Error", message: ErrorMessage.unknown.rawValue)
                self.loginButton.stopLoading()
            }
            
        }, onFailure: { (errorResponse) in
            AlertHelper.showAlert(in: self, withTitle: "Error", message: errorResponse?.error ?? ErrorMessage.unknown.rawValue)
            self.loginButton.stopLoading()
        }, onCompletion: nil)
        
    }
    
    @IBAction func signUpButtonDidReceiveTouchUpInside(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!, options: [:], completionHandler: nil)
    }
    
    
}

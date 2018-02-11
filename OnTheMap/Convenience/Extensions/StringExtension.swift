//
//  StringExtension.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 04/02/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidUrl: Bool {
        guard let url = URL(string: self), !self.isEmpty else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
}

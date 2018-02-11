//
//  UIBarButtomItemExtension.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 11/02/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    var view: UIView? {
        return self.value(forKey: "view") as? UIView
    }
    
}

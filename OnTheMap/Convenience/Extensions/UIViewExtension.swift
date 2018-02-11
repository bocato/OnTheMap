//
//  UIViewExtension.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 27/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

extension UIView {
    
    func configureRoundedBorders(with borderWidth: CGFloat = 0.1,
                                 cornerRadius: CGFloat = 10,
                                 borderColor: CGColor = UIColor.clear.cgColor) {
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}



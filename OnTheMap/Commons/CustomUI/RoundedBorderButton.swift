//
//  RoundedBorderButton.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 27/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class RoundedBorderButton: UIButton {

    // MARK: - Properties
    @IBInspectable var borderWidth: CGFloat = 0.1
    @IBInspectable var cornerRadius: CGFloat = 4.0
    @IBInspectable var borderColor: UIColor = UIColor.clear
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureRoundedBorders(with: borderWidth, cornerRadius: cornerRadius, borderColor: borderColor.cgColor)
    }

}

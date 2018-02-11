//
//  StudentLocationTableViewCell.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 10/02/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class StudentLocationTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var mediaUrlLabel: UILabel!
    
    // MARK: - Configuration
    func configure(with studentLocation: StudentInformation?) {
        guard let firstName = studentLocation?.firstName, let lastName = studentLocation?.lastName, let mediaUrl = studentLocation?.mediaURL else {
            return
        }
        nameLabel.text = "\(firstName) \(lastName)"
        mediaUrlLabel.text = mediaUrl
    }
}

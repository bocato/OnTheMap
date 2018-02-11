//
//  User.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 31/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var firstName: String?
    var lastName: String?
    var email: Email?
    var key: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email, key
    }
    
}

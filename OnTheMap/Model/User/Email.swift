//
//  Email.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 31/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

struct Email: Codable {
    
    var verificationCodeSent: Bool = false
    var verified: Bool = false
    var address: String?
    
    enum CodingKeys: String, CodingKey {
        case verificationCodeSent = "_verification_code_sent"
        case verified = "_verified"
        case address
    }
    
}

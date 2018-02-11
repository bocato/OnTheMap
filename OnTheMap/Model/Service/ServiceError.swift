//
//  ServiceError.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 29/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

struct ServiceError: Codable, Error {
    
    // MARK: - Properties
    var error: String?
    var status: Int?
    
}

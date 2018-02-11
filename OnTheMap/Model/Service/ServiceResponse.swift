//
//  ServiceResponse.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 29/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

struct ServiceResponse {
    
    // MARK: - Properties
    var data: Data?
    
    var rawResponse: String?
    var response: HTTPURLResponse?
    var request: URLRequest?
    
    var serviceError: ServiceError?
    
}

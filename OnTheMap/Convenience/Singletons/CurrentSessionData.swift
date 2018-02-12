//
//  CurrentSessionData.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 02/02/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class CurrentSessionData {

    // MARK: - Singleton
    static let shared = CurrentSessionData()
    
    // MARK: - Properties
    var udacitySession: SessionResponse?
    var userData: User?
    var studentLocations: [StudentInformation]?
    
    // MARK: - Methods
    func clearData() {
        udacitySession = nil
        userData = nil
        studentLocations = nil
    }
    
}

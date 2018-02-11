//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 31/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation: Codable {
    
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
    
}

extension StudentInformation {
    
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = latitude, let longitude = longitude else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
    
}
